trace(fl.configDirectory);
var instanceIndex = 0;
var currentFolder = "";
var currentDocument = fl.getDocumentDOM();
if(currentDocument)
{
	closeTempFile();
	removeTempFile(true);
	saveAsFla();
	//createBitmapFolder();
	convertAll();
	removeUnUseItem();
	//clearTimeLine();
	//fl.getDocumentDOM().close(true);
	createSpriteSheet();
	createXML();
	//saveAsXfl();
	//exitEditMode()
	//closeFile(getSaveAsFlaPath(),true,true);
	//abc;
	//saveAsXfl();
	pack();
	closeTempFile();
	//callSwfPanel();
	//removeTempFile();
	//fl.setActiveWindow(currentDocument);
}else
{
	alert("当前没有正在打开的fla文件。");
}


function callSwfPanel()
{
	var swf = fl.getSwfPanel("StarlingExtension");
	if(swf)
	{
		swf.call("loadPackFile",getSaveAsPackSwfPath());
	}
}

/////////////////////////////////////////////////////////////////////
//位图转换相关
/////////////////////////////////////////////////////////////////////
function convertAll()
{
	//clear();
	//trace(fl.configDirectory);
	//trace(fl.configURI);
	exitEditMode();
	//转换舞台
	var document = fl.getDocumentDOM();
	var library = document.library;
	convertTimeLine(document.getTimeline(),library,document);
	convertLibrary();
}
function convertLibrary()
{
	exitEditMode();
	var document = fl.getDocumentDOM();
	var library = document.library;
	var items = library.items;
	var editItemTypes = ["movie clip","graphic","button"];
	for(var i = 0;i<items.length;i++)
	{
		var item = items[i];
		//trace(item.name + "," + item.itemType);
		if(editItemTypes.indexOf(item.itemType) != -1)
		{
			library.editItem(item.name);
			//trace("==========Converting,"+item.name);
			convertTimeLine(document.getTimeline(),library,document);
		}
	}
	exitEditMode();
}
function convertTimeLine(timeline,library,document)
{
	var layers = timeline.layers;
	for(var i = 0;i<layers.length;i++)
	{
		var layer = layers[i];
		if(layer.layerType == "normal")
		{
			if(layer.locked)
			{
				layer.locked = false;
			}
			if(!layer.visible)
			{
				layer.visible = true;
			}
			convertLayer(layer,timeline,library,document);
		}
	}
}
function convertLayer(layer,timeline,library,document)
{
	var frames = layer.frames;
	for(var i = 0;i<frames.length;i++)
	{
		var frame = frames[i];
		timeline.currentFrame = i;
		convertFrame(frame,layer,timeline,library,document);
	}
}
function convertFrame(frame,layer,timeline,library,document)
{
	document.selectNone();
	//注意,转换为位图后层级会调整,需要处理层级(能优化)
	//library.moveToFolder()
	var elements = frame.elements;
	convertElements(elements,false,frame,layer,timeline,library,document);
}
function convertElements(elements,isGroup,frame,layer,timeline,library,document)
{
	var afes = [];//保存处理后的对象(保存层级)
	var isConvertd = false;
	var i;
	var element;
	for(i = 0;i<elements.length;i++)
	{
		element = elements[i];
		trace("element,"+element.name+","+element.elementType);
		if(element.elementType == "shape" && element.isGroup)
		{
			convertGroup(element,frame,layer,timeline,library,document);
			afes.push(element);
		}else if(element.elementType == "shape")
		{
			// fl.getDocumentDOM().enterEditMode('inPlace');
			if(isGroup)
			{
				document.selectAll();
				unselect(element);
			}else
			{
				element.selected = true;
			}
			document.convertSelectionToBitmap();
			//转换完后会黑夜选中转换后的位图
			var bitmap = document.selection[0];
			afes.push(bitmap);
			var bitmapItem = bitmap.libraryItem;
			setBitmapQuality(bitmapItem);
			document.selectNone();
			isConvertd = true;
			//trace("bitmap.libraryItem,"+);
			//var targetName = "Convert Bitmap "+(convertBitmapIndex++);
			//if(!library.itemExists(targetName))
			//{
			//	bitmapItem.name = targetName;
			//}
			//library.moveToFolder(convertBitmapFolder,bitmapItem.name,false);
			//bitmapItem.name = "Convert Bitmap "+(convertBitmapIndex++);
			//bitmap.selected = true;
			//element = fl.getDocumentDOM().selection[0];
			//element.depth = i;
			//break;
			
			//trace("Convert Shape To Bitmap");
			
		}else if(element.elementType == "text" && element.textType == "static")
		{
			element.selected = true;
			while(document.selection.length > 1)
			{
				document.selection[1].selected = false;
			}
			document.convertSelectionToBitmap();
			var bitmap = document.selection[0];
			afes.push(bitmap);
			var bitmapItem = bitmap.libraryItem;
			setBitmapQuality(bitmapItem);
			document.selectNone();
			isConvertd = true;
		}else
		{
			
			afes.push(element);
		}
	}
	//有转换操作，处理层级
	if(isConvertd && afes.length > 1)
	{
		for(i=0;i<afes.length;i++)
		{
			element = afes[i];
			//trace("[arrange]["+i+"]"+element);
			element.selected = true;
			document.arrange('front');
			document.selectNone();
		}
	}
}
function convertGroup(group,frame,layer,timeline,library,document)
{
	//trace("[convertGroup]");
	document.selectNone();
	group.selected = true;
	
	document.enterEditMode('inPlace');
	
	document.selectAll();
	var elements = document.selection;
	elements.reverse();
	convertElements(elements,true,frame,layer,timeline,library,document);
	document.exitEditMode();
}
function setBitmapQuality(bitmapItem)
{
	bitmapItem.allowSmoothing = false;
	bitmapItem.compressionType = "photo";
	bitmapItem.useImportedJPEGQuality = false;
	bitmapItem.quality = 100;
	
	//bitmapItem.allowSmoothing;//一个布尔值,它指定是否允许对位图进行平滑处理。
	//bitmapItem.compressionType;//一个字符串,它确定应用于位图的图像压缩类型。
	//bitmapItem.fileLastModifiedDate;//从 1970 年 1 月 1 日至原始文件修改日期之间的秒数。
	//bitmapItem.originalCompressionType;//指定项目是否是以 jpeg 文件格式导入的。
	//bitmapItem.sourceFileExists;//指定之前导入库中的文件现在是否仍位于其导入时的源位置。
	//bitmapItem.sourceFileIsCurrent;//指定库项目的文件修改日期是否与其导入时在磁盘上的文件修改日期相同。
	//bitmapItem.sourceFilePath;//导入库中的文件的路径和名称。
	//bitmapItem.useDeblocking;//指定是否启用消除马赛克功能。
	//bitmapItem.useImportedJPEGQuality;//一个布尔值,它指定是否使用默认的 JPEG 导入品质。
}
/*
function createBitmapFolder()
{
	var library = fl.getDocumentDOM().library;
	var index = 1;
	while(library.itemExists("ConvertBitmapFolder"+index))
	{
		index++;
	}
	library.newFolder("ConvertBitmapFolder"+index);
	convertBitmapFolder = "ConvertBitmapFolder"+index;
}*/



function removeUnUseItem()
{
	var document = fl.getDocumentDOM();
	var library = document.library;
	var items = library.unusedItems;
	if(items){
	while(items.length > 0)
	{
		for(var i=0;i<items.length;i++)
		{
			var item = items[i];
			library.deleteItem(item.name);
		}
		items = library.unusedItems;
	}
	}
}



function createSpriteSheet()
{
	var bitmapIndex = 0;
	
	var exporter = new SpriteSheetExporter();
	exporter.algorithm = "maxRects";
	exporter.autoSize = true;
	exporter.allowTrimming = true;
	exporter.layoutFormat = "Starling";
	exporter.borderPadding = 2;
	exporter.shapePadding = 2;
	var document = fl.getDocumentDOM();
	var library = document.library;
	var items = library.items;
	var index = 0;
	for(var i = 0;i<items.length;i++)
	{
		var item = items[i];
		//trace(item.name+"|"+item.itemType);
		if(item.itemType == "bitmap")
		{
			item.name = getRandomName();
			library.moveToFolder("/",item.name,true);
			exporter.addBitmap(item);
			if(exporter.sheetWidth > 2048 || exporter.sheetHeight > 2048)
			{
				exporter.removeBitmap(item);
				fl.trace(exporter.exportSpriteSheet(getSaveSpriteSheetPath(index++),{format:"png", bitDepth:32, backgroundColor:"#00000000"},true));
				exporter.beginExport();
				exporter.algorithm = "maxRects";
				exporter.autoSize = true;
				exporter.allowTrimming = true;
				exporter.layoutFormat = "Starling";
				exporter.borderPadding = 2;
				exporter.shapePadding = 2;
			}
			exporter.addBitmap(item);
		}
	}
	fl.trace(exporter.exportSpriteSheet(getSaveSpriteSheetPath(index++),{format:"png", bitDepth:32, backgroundColor:"#00000000"},true));
}






/*function pack()
{
	var linkagesStr = getLinkages();
	
	var document = fl.createDocument();;
	//fl.saveDocument(document,getSaveAsPackPath());
	document.saveAsCopy(getSaveAsPackPath());
	//document.saveAsCopy
	document.close(false);
	document = fl.openDocument(getSaveAsPackPath());
	//return;
	//image(0)
	document.importFile(getSaveSpriteSheetPath()+".png",false);
	var libraryItem = document.library.items[0];
	libraryItem.linkageExportForAS = true;
	libraryItem.linkageClassName = "SpriteSheetBitmapClass";
	//spriteSheet config(1);
	createTextMovieClip("spriteSheet_xml",FLfile.read(getSaveSpriteSheetPath()+".xml"));
	//library config(2);
	createTextMovieClip("library_xml",linkagesStr);
	//DOMDocument config(3);
	createTextMovieClip("DOMDocument_xml",FLfile.read(getSaveAsXflFolder()+"DOMDocument.xml"));
	
	createSymbolItemTextMovieClip(getSaveAsXflFolder()+"LIBRARY/","");
	
	document.save();
	document.publish();
}*/
function pack()
{
	var document = fl.createDocument();;
	//fl.saveDocument(document,getSaveAsPackPath());
	document.saveAsCopy(getSaveAsPackPath());
	//document.saveAsCopy
	document.close(false);
	document = fl.openDocument(getSaveAsPackPath());
	//return;
	//DOMDocument config(0);
	createTextMovieClip("DOMDocument_xml",FLfile.read(getFlaDomXmlPath()));
	var i = 0;
	while(FLfile.exists(getSaveSpriteSheetPath(i)+".png"))
	{
		//image(1)
		document.importFile(getSaveSpriteSheetPath(i)+".png",false);
		var libraryItem = document.library.items[document.library.findItemIndex(getCurrentFileName()+'_spriteSheet'+i+'.png')];
		libraryItem.linkageExportForAS = true;
		libraryItem.linkageClassName = "SpriteSheetBitmapClass"+i;
		//spriteSheet config(2);
		createTextMovieClip("spriteSheet"+i+"_xml",FLfile.read(getSaveSpriteSheetPath(i)+".xml"));
		i++;
	}

	document.save();
	document.publish();
}
function getLinkages()
{
	var linkages = [];
	var document = fl.getDocumentDOM();
	var library = document.library;
	var items = library.items;
	for(var i = 0;i<items.length;i++)
	{
		var item = items[i];
		if(item.linkageExportForAS)
		{
			linkages.push("<SymbolItem name=\""+item.name+"\" linkageBaseClass=\""+item.linkageBaseClass+"\" linkageClassName=\""+item.linkageClassName+"\"/>");
			//linkages.push({name:item.name,linkageBaseClass:item.linkageBaseClass,linkageClassName:item.linkageClassName});
		}
	}
	return "<LinkageSymbols>"+linkages.join("\n")+"</LinkageSymbols>";
}
function createSymbolItemTextMovieClip(path,subPath)
{
	var i;
	var folders = FLfile.listFolder(path,"directories");
	for(i = 0;i<folders.length;i++)
	{
		createSymbolItemTextMovieClip(path + folders[i]+"/",subPath + folders[i]+"/");
	}
	var files = FLfile.listFolder(path,"files");
	for(i = 0;i<files.length;i++)
	{
		if(isLastString(files[i].toLocaleLowerCase(),".xml"))
		{
			createTextMovieClip((subPath+getFileName(files[i])).replace(/ /g,"_").replace(/\//g,"_")+"_xml",FLfile.read(getSaveAsXflFolder()+"LIBRARY/"+files[i]));
		}
	}
}




function createTextMovieClip(name,content)
{
	var document = fl.getDocumentDOM();
	var library = document.library;
	library.addNewItem('movie clip',name);
	//var item = library.items[library.findItemIndex(name)];
	library.selectNone();
	library.selectItem(name);
	library.editItem(name);
	var length = 2000;
	for(var i = 0;1;i++)
	{
		var subContent = content.substr(i*length,length);
		if(subContent.length < 1)
		{
			break;
		}
		//subContent = subContent.replace(/\r/g,"");
		//subContent = subContent.replace(/\n/g,"");
		createTextField(i,subContent);
	}
	exitEditMode();
	library.addItemToDocument({x:0,y:0},name);
	var element = document.selection[0];
	element.name = name;
	//element.x = 0;
	//element.y = 0;
	//document.setTransformationPoint({x:0, y:0});
	//document.moveSelectionBy({x:0, y:0});
}

function createTextField(index,content)
{
	//return;
	var document = fl.getDocumentDOM();
	document.getTimeline().addNewLayer("layer_"+index);
	//var layer = document.getTimeline().layers[0];
	//layer.frames[0].name = content;
	document.addNewText({left:0, top:0, right:100, bottom:100},"　");
	//var element = document.selection[0];
	//element.textType = "dynamic";
	//document.setTextString(content);
	//var text = document.getTimeline().layers[index].frames[0].elements[0];
	//trace(text);
	document.selectAll();
	var text = document.selection[0];
	
	//_sans
	//document.mouseClick({x:index * 100 + 5 , y:0 + 5}, false, true);
	document.setElementProperty('textType', 'input');//dynamic
	document.setElementProperty('fontRenderingMode', 'device');
	document.setElementTextAttr('face', '_sans');
	document.setElementTextAttr('size', 1);
	//document.setElementProperty('selectable', false);
	document.setElementProperty('scrollable', true);
	document.setElementProperty('border', false);
	document.setElementProperty('renderAsHTML', false);
	document.setElementProperty('lineType', 'single line');
	document.setTextString(content);
	document.setFillColor('#000000');
	//document.setTextRectangle({left:index * 100, top:0, right:index * 100 + 100, bottom:100});
	
	//var text = document.selection[0];
	//trace(text);
	//document.setTextRectangle({left:index * 100, top:0, right:index * 100 + 100, bottom:100});
	//document.setTextRectangle({left:index * 100, top:0, right:index * 100 + 100, bottom:100});
	//text.textType = "dynamic";
	//text.letterSpacing = 0;
	//text.border = true;
	//text.scrollable = true;
	//text.setTextString(content);
	//text.x = 0;
	//text.y = 0;
	//text.width = 100;
	//text.height = 100;
	text.name = "text"+index;
	getLayer("layer_"+index).visible = false;
	getLayer("layer_"+index).locked = true;
	
	document.selectNone();	
}

function getLayer(name)
{
	var layers = fl.getDocumentDOM().getTimeline().layers;
	for(var i=0;i<layers.length;i++)
	{
		var layer = layers[i];
		if(layer.name == name)
		{
			return layer;
		}
	}
	return null;
}




function createXML()
{
	var document = fl.getDocumentDOM();
	var library = document.library;
	var items = library.items;
	var itemStrs = [];
	var timelineStrs = [];
	
	exitEditMode();
	var rootTimelineName = getRandomName();
	timelineStrs.push(outputTimeLine(rootTimelineName,document.getTimeline(),library,document));
	
	var itemTemp = '<item name="{name}" itemType="{itemType}" linkageExportForAS="{linkageExportForAS}" linkageClassName="{linkageClassName}"/>';
	for(var i=0;i<items.length;i++)
	{
		var item = items[i];
		var typeInfo = getItemInfo(item.itemType);
		if(typeInfo)
		{
			var itemStr = itemTemp;
			itemStr = itemStr.replace("{name}",item.name);
			itemStr = itemStr.replace("{itemType}",typeInfo.type);
			itemStr = replaceTemp(itemStr,item,["name","linkageExportForAS","linkageClassName"]);
			itemStrs.push(itemStr);
			if(typeInfo.container)
			{
				library.editItem(item.name);
				timelineStrs.push(outputTimeLine(item.name,document.getTimeline(),library,document));
			} 
		}
	}
	//trace(itemStrs.join("\r"));
	//trace(timelineStrs.join("\r"));
	var xmlStr = '<DOMDocument timeline="'+rootTimelineName+'">';
	xmlStr += '\r<library>\r'+itemStrs.join("\r")+"\r</library>";
	xmlStr += '\r<timelines>\r'+timelineStrs.join("\r")+'\r</timelines>';
	xmlStr += '</DOMDocument>';
	FLfile.write(getFlaDomXmlPath(), xmlStr);
}


function getItemInfo(itemType)
{
	var itemTypeInfo = {};
	itemTypeInfo["button"] = {type:"Button",container:true};
	itemTypeInfo["movie clip"] = {type:"Sprite",container:true};
	itemTypeInfo["graphic"] = {type:"Sprite",container:true};
	itemTypeInfo["bitmap"] = {type:"Bitmap",container:false};
	return itemTypeInfo[itemType];
}



function outputTimeLine(name,timeline,library,document)
{
	var timelineStr = '<timeline name="'+name+'">';
	var frameCount = timeline.frameCount;
	for(var i=0;i<frameCount;i++)
	{
		timeline.currentFrame = i;
		timelineStr += outputLayer(i,timeline,library,document);
	}
	timelineStr += '\r</timeline>';
	return timelineStr;
}
function outputLayer(index,timeline,library,document)
{
	var frameStr = '';
	var labels = [];
	var layers = timeline.layers;
	for(var i = 0;i<layers.length;i++)
	{
		var layer = layers[i];
		if(layer.layerType == "normal")
		{
			if(layer.locked)
			{
				layer.locked = false;
			}
			if(!layer.visible)
			{
				layer.visible = true;
			}
			var frame = layer.frames[timeline.currentFrame];
			if(frame)
			{
				if(frame.name)
				{
					labels.push(frame.name);
				}
				frameStr += outputFrame(frame,layer,timeline,library,document)
			}
		}
	}
	return '\r<frame index="'+index+'" labels="'+labels.join(",")+'">' + frameStr + '\r</frame>';
}
function outputFrame(frame,layer,timeline,library,document)
{
	document.selectNone();
	var elements = frame.elements;
	return outputElements(elements,false,frame,layer,timeline,library,document);
}
function outputElements(elements,isGroup,frame,layer,timeline,library,document)
{
	var elementsStr = '';
	var elementTemp = '<element name="{name}" elementType="{elementType}" libraryItem="{libraryItem}" x="{x}" y="{y}" width="{width}" height="{height}" scaleX="{scaleX}" scaleY="{scaleY}" rotation="{rotation}" alpha="{alpha}">';
	var elementTextTemp = '<element name="{name}" elementType="{elementType}" libraryItem="{libraryItem}" x="{x}" y="{y}" width="{width}" height="{height}" scaleX="{scaleX}" scaleY="{scaleY}" rotation="{rotation}" alpha="{alpha}" border="{border}" lineType="{lineType}" maxCharacters="{maxCharacters}" orientation="{orientation}" renderAsHTML="{renderAsHTML}" scrollable="{scrollable}" selectable="{selectable}" textType="{textType}">';
	elements = elements.sort(elementSortFUnc)
	for(var i = 0;i<elements.length;i++)
	{
		var element = elements[i];
		if(element.elementType == "shape" && element.isGroup)
		{
			elementsStr += outputGroup(element,frame,layer,timeline,library,document);
		}else
		{
			var elementStr = elementTemp;
			if(element.elementType == "text")
			{
				elementStr = elementTextTemp;
			}
			//非文本框也非库对象
			if(element.elementType != "text")
			{
				if(!element.libraryItem)
				{
					continue; 
				}
				if(!getItemInfo(element.libraryItem.itemType))
				{
					continue;
				}
			}
			if(!element.name)
			{
				element.name = "instance"+(++instanceIndex);
			}
			
			elementStr = elementStr.replace("{elementType}",element.elementType == "text"?"TextField":getItemInfo(element.libraryItem.itemType).type);
			elementStr = elementStr.replace("{libraryItem}",element.libraryItem?element.libraryItem.name:"");
			elementStr = replaceTemp(elementStr,element,["name","x","y","width","height","scaleX","scaleY","lineType","orientation","textType"]);
			elementStr = elementStr.replace("{alpha}",element.colorAlphaPercent||100);
			elementStr = elementStr.replace("{rotation}",element.rotation||0);
			elementStr = elementStr.replace("{border}",element.border||'false');
			elementStr = elementStr.replace("{renderAsHTML}",element.renderAsHTML||'false');
			elementStr = elementStr.replace("{scrollable}",element.scrollable||'false');
			elementStr = elementStr.replace("{selectable}",element.selectable||'false');
			elementStr = elementStr.replace("{maxCharacters}",element.maxCharacters||'false');
			if(element.elementType == "text")
			{
				elementStr += '\r<text>\r<![CDATA['+element.getTextString()+']]>\r</text>';
				elementStr += getTextFormat(element);
			}
			elementStr += getFilters(element.getFilters());
			elementStr += '\r</element>';
			//trace(element.getFilters());
			elementsStr += '\r'+elementStr;
		}
	}
	return elementsStr;
}
function getTextFormat(element)
{
	var textAttr = element.textRuns[0].textAttrs;//blockIndent="{blockIndent}" bullet="{bullet}" tabStops="{tabStops}"  
	var formatTemp = '\r<textformat align="{align}" bold="{bold}" color="{color}" font="{font}" indent="{indent}" italic="{italic}" kerning="{kerning}" leading="{leading}" leftMargin="{leftMargin}" letterSpacing="{letterSpacing}" rightMargin="{rightMargin}" size="{size}" target="{target}" underline="{underline}" url="{url}"/>';
	var formatStr = formatTemp;
	formatStr = formatStr.replace("{align}",textAttr.alignment);
	formatStr = formatStr.replace("{indent}",textAttr.indent||0);
	formatStr = formatStr.replace("{bold}",textAttr.bold||'false');
	formatStr = formatStr.replace("{italic}",textAttr.italic||'false');
	formatStr = formatStr.replace("{kerning}",textAttr.autoKern||'false');
	formatStr = formatStr.replace("{underline}",textAttr.underline||'false');
	formatStr = formatStr.replace("{color}",textAttr.fillColor);
	formatStr = formatStr.replace("{font}",textAttr.face);
	formatStr = formatStr.replace("{leading}",textAttr.lineSpacing);
	formatStr = formatStr.replace("{leftMargin}",textAttr.leftMargin||0);
	formatStr = formatStr.replace("{letterSpacing}",textAttr.letterSpacing||0);
	formatStr = formatStr.replace("{rightMargin}",textAttr.rightMargin||0);
	formatStr = formatStr.replace("{font}",textAttr.face);
	formatStr = replaceTemp(formatStr,textAttr,["size","target","url"]);
	return formatStr;
	
}
function getFilters(filters)
{
	if(filters.length < 1)
	{
		return "";
	}
	var filtersStr = '\r<filters>';
	var filterTemp = '<filter name="{name}" angle="{angle}" blurX="{blurX}" blurY="{blurY}" brightness="{brightness}" color="{color}" contrast="{contrast}" distance="{distance}" enabled="{enabled}" hideObject="{hideObject}" highlightColor="{highlightColor}" hue="{hue}" inner="{inner}" knockout="{knockout}" quality="{quality}" saturation="{saturation}" shadowColor="{shadowColor}" strength="{strength}" type="{type}"/>';
	for(var i=0;i<filters.length;i++)
	{
		var filter = filters[i];
		var filterStr = filterTemp;
		filterStr = replaceTemp(filterStr,filter,["name","angle","blurX","blurY","brightness","color","contrast","distance","enabled","hideObject","highlightColor","hue","inner","knockout","quality","saturation","shadowColor","strength","type"]);
		filtersStr += '\r'+filterStr;
	}
	filtersStr += '\r</filters>';
	return filtersStr;
}
function replaceTemp(str,obj,list)
{
	for each(var i in list)
	{
		str = str.replace("{"+i+"}",obj[i]||'');
	}
	return str;
}
function elementSortFUnc(a,b)
{
	return a.depth > b.depth ? 1 : -1;
}

function outputGroup(group,frame,layer,timeline,library,document)
{
	document.selectNone();
	group.selected = true;
	
	document.enterEditMode('inPlace');
	
	document.selectAll();
	var elements = document.selection;
	//elements.reverse();
	var str = outputElements(elements,true,frame,layer,timeline,library,document);
	document.exitEditMode();
	return str;
}











/////////////////////////////////////////////////////////////////////
//保存相关
/////////////////////////////////////////////////////////////////////
function saveAsXfl()
{
	var document = fl.getDocumentDOM();
	document.save();
	document.saveAsCopy(getSaveAsXflPath());
}

function saveAsFla()
{
	//获取另存的名字
	fl.setActiveWindow(currentDocument);
	var flaPath = getSaveAsFlaPath();
	//另存
	fl.getDocumentDOM().saveAsCopy(flaPath);
	//打开
	fl.openDocument(flaPath);
}
function closeTempFile()
{
	//关闭xfl
	closeFile(getSaveAsXflPath(),true,true);
	//关闭临时打包文件
	closeFile(getSaveAsPackPath(),true,true);
	//如果转换后的文件正在打开，关闭之	
	closeFile(getSaveAsFlaPath(),true,true);
}
function removeTempFile(createFolder)
{
	var path = getTempFolder();
	//删除
	if(FLfile.exists(path))
	{
		FLfile.remove(path);
	}
	if(createFolder)
	{
		FLfile.createFolder(path);
	}
}







/////////////////////////////////////////////////////////////////////
//路径相关
/////////////////////////////////////////////////////////////////////
function getFlaDomXmlPath()
{
	return getTempFolder() + getCurrentFileName() + "_dom.xml";
}
function getSaveSpriteSheetPath(index)
{
	return getTempFolder() + getCurrentFileName() + "_spriteSheet"+index;
}
function getSaveAsXflFolder()
{
	return getTempFolder() + getCurrentFileName() + "_convert/";
}
function getSaveAsXflPath()
{
	return getTempFolder() + getCurrentFileName() + "_convert.xfl";
}
function getSaveAsXflName()
{
	return getTempFolder() + "_convert.xfl";
}
function getSaveAsFlaPath()
{
	return getTempFolder() + getCurrentFileName() + "_convert.fla";
}
function getSaveAsPackPath()
{
	return getTempFolder() + getCurrentFileName() + "_pack.fla";
}
function getSaveAsPackSwfPath()
{
	return getTempFolder() + getCurrentFileName() + "_pack.swf";
}
function getCurrentFileName()
{
	var name = currentDocument.pathURI.split("/").pop();
	var parts = name.split(".");
	parts.pop();
	return parts.join(".");
}
function getTempFolder()
{
	return getCurrentFolder() + getCurrentFileName() + "_temp/";
}
function getCurrentFolder()
{
	var parts = currentDocument.pathURI.split("/");
	parts.pop();
	return parts.join("/") + "/";
}
function getFileName(name)
{
	var parts = name.split(".");
	parts.pop();
	return parts.join(".");
}






/////////////////////////////////////////////////////////////////////
//通用的方法
/////////////////////////////////////////////////////////////////////
function clear()
{
	fl.outputPanel.clear();
}
function trace(str)
{
	fl.trace(str);
}
//退出所有编辑(回到主场景)
function exitEditMode()
{
	var document = fl.getDocumentDOM();
	while(document.getTimeline() != document.timelines[0])
	{
		document.exitEditMode();
	}
	document.selectNone();
}
//清空主场景
function clearTimeLine()
{
	exitEditMode();
	var timeline = fl.getDocumentDOM().getTimeline();
	while(timeline.frameCount > 1)
	{
		timeline.removeFrames();
	}
	timeline.removeFrames();
	timeline.insertFrames();
}
//获取随机名字
function getRandomName()
{
	var name = Math.random().toString().split(".")[1];
	while(name.length < 20)
	{		
		name += "0";
	}
	return name;
}

//关闭指定文件
function closeFile(target,isFullPath,isSaveFile)
{
	var documents = fl.documents;
	for(var i = 0;i<documents.length;i++)
	{
		var document = documents[i];
		if(isFullPath)
		{
			if(document.pathURI == target)
			{
				//if(isSaveFile)
				//{
				//	document.saveAsCopy(document.pathURI+".close");
				//}
				//fl.closeDocument(document,false);
				document.revert();	
				document.close();
				return;
			}	
		}else
		{
			//var index = document.pathURI.indexOf(target);
			//trace(document.pathURI.length - target.length);
			if(isLastString(document.pathURI.length,target))
			{
				document.close(false);
				return;
			}
		}
	}	
}
function isLastString(source,target)
{
	var index = source.indexOf(target);
	//trace(document.pathURI.length - target.length);
	if(index != -1 && index == source.length - target.length)
	{
		return true;
	}
	return false;
}
function unselect(element)
{
	var elements = fl.getDocumentDOM().selection;
	for(var i = 0;i<elements.length;i++)
	{
		if(elements[i] != element)
		{
			elements[i].selected = false;
		}
	}
}