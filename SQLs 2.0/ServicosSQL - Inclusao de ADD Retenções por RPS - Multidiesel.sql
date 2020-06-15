/* 
Autor: carlosjunior 
Data: 21/12/2017 
Descrição: ServicosSQL - Inclusao de ADD Retenções por RPS
*/ 

select nsview.public_unregister_nsview('vw_faturamento_nfse', 4, 1);

select nsview.public_register_nsview('vw_faturamento_nfse', 4, 1,'');

select nsview.public_register_label(
	'vw_faturamento_nfse',
	'Faturamento de NFS-e',
	'Faturamento de NFS-e');

delete from nsview.analisesdinamicasdedados where formulario = 'ddb79931-c44c-4f33-8784-575c3bd8dbc5';

delete from nsview.formularios where formulario = 'ddb79931-c44c-4f33-8784-575c3bd8dbc5';

insert into nsview.formularios (formulario, nome, nsview_id) values 
('ddb79931-c44c-4f33-8784-575c3bd8dbc5','Retenções por RPS',(select id from nsview.views where view_name = 'vw_faturamento_nfse'));

insert into nsview.analisesdinamicasdedados (analisedinamicadedados,sistema,modulo,nome,formulario,nsview_id) values(
'cdfa16a6-fce2-469f-a263-57a67764fa2b',4,1,'Retenções por RPS','ddb79931-c44c-4f33-8784-575c3bd8dbc5',(select id from nsview.views where view_name = 'vw_faturamento_nfse'));

delete from ns.layoutsrelatoriosfoldersctl where nome = 'Retenções por RPS';

delete from ns.layoutsrelatorios where nome = 'Retenções por RPS';

INSERT INTO ns.layoutsrelatoriosfoldersctl(nome, parentid, modulo, versao, sistema) VALUES('Retenções por RPS',0,1,1,4);

INSERT INTO ns.layoutsrelatorios(folderid, itemtype, size, template, nome, padrao, mostramenu, sistema, relatorio,add_id) VALUES(
(SELECT layoutrelatoriofolder FROM ns.layoutsrelatoriosfoldersctl WHERE NOME = 'Retenções por RPS' LIMIT 1),1,42915,
'object reportEditorRelatorio: TppReport
  AutoStop = False
  DataPipeline = plnsView
  NoDataBehaviors = [ndMessageDialog, ndBlankPage]
  PassSetting = psTwoPass
  PrinterSetup.BinName = ''Default''
  PrinterSetup.DocumentName = ''Relat''#243''rio''
  PrinterSetup.PaperName = ''A4''
  PrinterSetup.PrinterName = ''Default''
  PrinterSetup.SaveDeviceSettings = False
  PrinterSetup.mmMarginBottom = 6350
  PrinterSetup.mmMarginLeft = 5000
  PrinterSetup.mmMarginRight = 5000
  PrinterSetup.mmMarginTop = 6350
  PrinterSetup.mmPaperHeight = 297000
  PrinterSetup.mmPaperWidth = 210000
  PrinterSetup.PaperSize = 9
  SaveAsTemplate = True
  Template.DatabaseSettings.DataPipeline = plItem
  Template.DatabaseSettings.Name = ''1053''
  Template.DatabaseSettings.NameField = ''layoutrelatorio''
  Template.DatabaseSettings.TemplateField = ''template''
  Template.SaveTo = stDatabase
  Template.Format = ftASCII
  Units = utMillimeters
  AllowPrintToArchive = True
  AllowPrintToFile = True
  ArchiveFileName = ''($MyDocuments)\ReportArchive.raf''
  DeviceType = ''Screen''
  DefaultFileDeviceType = ''PDF''
  EmailSettings.ReportFormat = ''PDF''
  EmailSettings.Enabled = True
  EmailSettings.ShowEmailDialog = True
  LanguageID = ''Portuguese (Brazil)''
  OutlineSettings.CreateNode = True
  OutlineSettings.CreatePageNodes = True
  OutlineSettings.Enabled = False
  OutlineSettings.Visible = False
  PDFSettings.EmbedFontOptions = []
  PDFSettings.EncryptSettings.AllowCopy = True
  PDFSettings.EncryptSettings.AllowInteract = True
  PDFSettings.EncryptSettings.AllowModify = True
  PDFSettings.EncryptSettings.AllowPrint = True
  PDFSettings.EncryptSettings.Enabled = False
  PDFSettings.FontEncoding = feAnsi
  PDFSettings.ImageCompressionLevel = 25
  PreviewFormSettings.WindowState = wsMaximized
  PreviewFormSettings.ZoomSetting = zsPageWidth
  RTFSettings.DefaultFont.Charset = DEFAULT_CHARSET
  RTFSettings.DefaultFont.Color = clWindowText
  RTFSettings.DefaultFont.Height = -13
  RTFSettings.DefaultFont.Name = ''Arial''
  RTFSettings.DefaultFont.Style = []
  TextFileName = ''($MyDocuments)\Report.pdf''
  TextSearchSettings.DefaultString = ''<FindText>''
  TextSearchSettings.Enabled = True
  XLSSettings.AppName = ''ReportBuilder''
  XLSSettings.Author = ''ReportBuilder''
  XLSSettings.Subject = ''Report''
  XLSSettings.Title = ''Report''
  Left = 488
  Top = 65
  Version = ''14.06''
  mmColumnWidth = 0
  DataPipelineName = ''plnsView''
  object ppHeaderBand1: TppHeaderBand
    Background.Brush.Style = bsClear
    mmBottomOffset = 0
    mmHeight = 16669
    mmPrintPosition = 0
    object rpRelatorioShape4: TppShape
      UserName = ''rpRelatorioShape4''
      Brush.Color = cl3DLight
      Pen.Color = clNone
      Pen.Style = psClear
      StretchWithParent = True
      mmHeight = 9260
      mmLeft = 265
      mmTop = 0
      mmWidth = 200025
      BandType = 0
      LayerName = Foreground
    end
    object ppNomeSistema: TppLabel
      UserName = ''lblNomeSistema''
      AutoSize = False
      Caption = ''Servi''#231''os SQL''
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 10
      Font.Style = []
      TextAlignment = taCentered
      Transparent = True
      mmHeight = 3969
      mmLeft = 265
      mmTop = 0
      mmWidth = 199761
      BandType = 0
      LayerName = Foreground
    end
    object ppDBText5: TppDBText
      UserName = ''dbNomeEstabelecimento''
      DataField = ''Nome do Estabelecimento''
      DataPipeline = plnsView
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 11
      Font.Style = []
      ParentDataPipeline = False
      TextAlignment = taCentered
      Transparent = True
      DataPipelineName = ''plnsView''
      mmHeight = 4498
      mmLeft = 265
      mmTop = 4498
      mmWidth = 199761
      BandType = 0
      LayerName = Foreground
    end
    object ppLabel4: TppLabel
      UserName = ''lblNasajonSistemas''
      Caption = ''Nasajon Sistemas''
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 10
      Font.Style = []
      Transparent = True
      mmHeight = 3969
      mmLeft = 529
      mmTop = 529
      mmWidth = 28310
      BandType = 0
      LayerName = Foreground
    end
    object ppCalc1: TppSystemVariable
      UserName = ''lblData''
      DisplayFormat = ''dd/mm/yyyy''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 8
      Font.Style = []
      Transparent = True
      mmHeight = 2910
      mmLeft = 529
      mmTop = 5556
      mmWidth = 14288
      BandType = 0
      LayerName = Foreground
    end
    object ppCalc2: TppSystemVariable
      UserName = ''lblHora''
      VarType = vtTime
      DisplayFormat = ''hh:mm:ss''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 8
      Font.Style = []
      TextAlignment = taRightJustified
      Transparent = True
      mmHeight = 2910
      mmLeft = 17198
      mmTop = 5556
      mmWidth = 11113
      BandType = 0
      LayerName = Foreground
    end
    object ppLabel6: TppLabel
      UserName = ''lblTituloRelatorio''
      Caption = ''Relat''#243''rio de reten''#231#245''es de NFS-e''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 12
      Font.Style = [fsBold]
      TextAlignment = taCentered
      Transparent = True
      mmHeight = 4995
      mmLeft = 67503
      mmTop = 10848
      mmWidth = 62018
      BandType = 0
      LayerName = Foreground
    end
    object ppPersonalizacao1: TppLabel
      UserName = ''lblPersonalizacao''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 10
      Font.Style = []
      TextAlignment = taRightJustified
      Transparent = True
      mmHeight = 4022
      mmLeft = 174890
      mmTop = 265
      mmWidth = 23813
      BandType = 0
      LayerName = Foreground
    end
    object NumeroPagina1: TppSystemVariable
      UserName = ''lblNumeroPagina''
      VarType = vtPageSetDesc
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 8
      Font.Style = []
      Transparent = True
      mmHeight = 3260
      mmLeft = 173832
      mmTop = 5556
      mmWidth = 25400
      BandType = 0
      LayerName = Foreground
    end
  end
  object ppDetailBand1: TppDetailBand
    Background1.Brush.Style = bsClear
    Background2.Brush.Style = bsClear
    PrintHeight = phDynamic
    mmBottomOffset = 0
    mmHeight = 0
    mmPrintPosition = 0
  end
  object ppSummaryBand2: TppSummaryBand
    Background.Brush.Style = bsClear
    mmBottomOffset = 0
    mmHeight = 4233
    mmPrintPosition = 0
    object ppLabel11: TppLabel
      UserName = ''lblTotalGeral''
      Caption = ''Total Geral:''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 8
      Font.Style = [fsBold]
      TextAlignment = taRightJustified
      Transparent = True
      mmHeight = 3387
      mmLeft = 18066
      mmTop = 793
      mmWidth = 15536
      BandType = 7
      LayerName = Foreground
    end
    object ppLine2: TppLine
      UserName = ''LineGroupFooter''
      Weight = 0.750000000000000000
      mmHeight = 265
      mmLeft = 265
      mmTop = 0
      mmWidth = 199496
      BandType = 7
      LayerName = Foreground
    end
    object ppDBCalc6: TppDBCalc
      UserName = ''dbValorNFSeGeral''
      DataField = ''Valor NFS-e''
      DataPipeline = plnsView
      DisplayFormat = ''#,0.00;-#,0.00''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 8
      Font.Style = [fsBold]
      ParentDataPipeline = False
      TextAlignment = taRightJustified
      Transparent = True
      DataPipelineName = ''plnsView''
      mmHeight = 3387
      mmLeft = 35454
      mmTop = 800
      mmWidth = 32279
      BandType = 7
      LayerName = Foreground
    end
    object ppDBCalc7: TppDBCalc
      UserName = ''dbValorIRRFGeral''
      DataField = ''Valor IRRF''
      DataPipeline = plnsView
      DisplayFormat = ''#,0.00;-#,0.00''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 8
      Font.Style = [fsBold]
      ParentDataPipeline = False
      TextAlignment = taRightJustified
      Transparent = True
      DataPipelineName = ''plnsView''
      mmHeight = 3387
      mmLeft = 114565
      mmTop = 800
      mmWidth = 20000
      BandType = 7
      LayerName = Foreground
    end
    object ppDBCalc8: TppDBCalc
      UserName = ''dbValorCSLLGeral''
      DataField = ''Valor CSLL''
      DataPipeline = plnsView
      DisplayFormat = ''#,0.00;-#,0.00''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 8
      Font.Style = [fsBold]
      ParentDataPipeline = False
      TextAlignment = taRightJustified
      Transparent = True
      DataPipelineName = ''plnsView''
      mmHeight = 3387
      mmLeft = 136525
      mmTop = 800
      mmWidth = 20000
      BandType = 7
      LayerName = Foreground
    end
    object ppDBCalc9: TppDBCalc
      UserName = ''dbValorPISGeral''
      DataField = ''Valor PIS''
      DataPipeline = plnsView
      DisplayFormat = ''#,0.00;-#,0.00''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 8
      Font.Style = [fsBold]
      ParentDataPipeline = False
      TextAlignment = taRightJustified
      Transparent = True
      DataPipelineName = ''plnsView''
      mmHeight = 3440
      mmLeft = 158486
      mmTop = 793
      mmWidth = 20000
      BandType = 7
      LayerName = Foreground
    end
    object ppDBCalc10: TppDBCalc
      UserName = ''dbValorCOFINSGeral''
      DataField = ''Valor COFINS''
      DataPipeline = plnsView
      DisplayFormat = ''#,0.00;-#,0.00''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 8
      Font.Style = [fsBold]
      ParentDataPipeline = False
      TextAlignment = taRightJustified
      Transparent = True
      DataPipelineName = ''plnsView''
      mmHeight = 3440
      mmLeft = 179652
      mmTop = 793
      mmWidth = 20000
      BandType = 7
      LayerName = Foreground
    end
    object ppDBCalc21: TppDBCalc
      UserName = ''dbValorIRRFGeral2''
      DataField = ''Valor INSS''
      DataPipeline = plnsView
      DisplayFormat = ''#,0.00;-#,0.00''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 8
      Font.Style = [fsBold]
      ParentDataPipeline = False
      TextAlignment = taRightJustified
      Transparent = True
      DataPipelineName = ''plnsView''
      mmHeight = 3387
      mmLeft = 92604
      mmTop = 794
      mmWidth = 20000
      BandType = 7
      LayerName = Foreground
    end
    object ppDBCalc28: TppDBCalc
      UserName = ''DBCalc28''
      DataField = ''Valor ISS''
      DataPipeline = plnsView
      DisplayFormat = ''#,0.00;-#,0.00''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Name = ''Arial''
      Font.Size = 8
      Font.Style = [fsBold]
      ParentDataPipeline = False
      TextAlignment = taRightJustified
      Transparent = True
      DataPipelineName = ''plnsView''
      mmHeight = 3387
      mmLeft = 69850
      mmTop = 794
      mmWidth = 20000
      BandType = 7
      LayerName = Foreground
    end
  end
  object ppGroup3: TppGroup
    BreakName = ''Nome do Estabelecimento''
    DataPipeline = plnsView
    GroupFileSettings.NewFile = False
    GroupFileSettings.EmailFile = False
    OutlineSettings.CreateNode = True
    NewPage = True
    StartOnOddPage = False
    UserName = ''Group3''
    mmNewColumnThreshold = 0
    mmNewPageThreshold = 0
    DataPipelineName = ''plnsView''
    NewFile = False
    object ppGroupHeaderBand3: TppGroupHeaderBand
      Background.Brush.Style = bsClear
      mmBottomOffset = 0
      mmHeight = 10054
      mmPrintPosition = 0
      object ppLabel13: TppLabel
        UserName = ''lblRazaoSocialCliente1''
        Caption = ''Estabelecimento:''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 3387
        mmLeft = 529
        mmTop = 3704
        mmWidth = 25665
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBText3: TppDBText
        UserName = ''dbRazaoSocialCliente1''
        DataField = ''Nome do Cliente''
        DataPipeline = plnsView
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = []
        ParentDataPipeline = False
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3175
        mmLeft = 29898
        mmTop = 3704
        mmWidth = 169334
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
    end
    object ppGroupFooterBand3: TppGroupFooterBand
      Background.Brush.Style = bsClear
      HideWhenOneDetail = False
      mmBottomOffset = 0
      mmHeight = 4233
      mmPrintPosition = 0
      object ppLabel14: TppLabel
        UserName = ''lblTotalGeral1''
        Caption = ''Total Estabelecimento:''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3387
        mmLeft = 529
        mmTop = 793
        mmWidth = 33073
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppLine4: TppLine
        UserName = ''LineGroupFooter1''
        Weight = 0.750000000000000000
        mmHeight = 265
        mmLeft = 265
        mmTop = 270
        mmWidth = 199761
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc16: TppDBCalc
        UserName = ''dbValorNFSeGeral1''
        DataField = ''Valor NFS-e''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup3
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 35454
        mmTop = 793
        mmWidth = 32279
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc17: TppDBCalc
        UserName = ''dbValorIRRFGeral1''
        DataField = ''Valor IRRF''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup3
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 114565
        mmTop = 793
        mmWidth = 20000
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc18: TppDBCalc
        UserName = ''dbValorCSLLGeral1''
        DataField = ''Valor CSLL''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup3
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 136525
        mmTop = 793
        mmWidth = 20000
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc19: TppDBCalc
        UserName = ''dbValorPISGeral1''
        DataField = ''Valor PIS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup3
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 158486
        mmTop = 793
        mmWidth = 20000
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc20: TppDBCalc
        UserName = ''dbValorCOFINSGeral1''
        DataField = ''Valor COFINS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup3
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 179652
        mmTop = 793
        mmWidth = 20000
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc22: TppDBCalc
        UserName = ''DBCalc22''
        DataField = ''Valor INSS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup3
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 92604
        mmTop = 794
        mmWidth = 20000
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc27: TppDBCalc
        UserName = ''DBCalc27''
        DataField = ''Valor ISS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup3
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 69850
        mmTop = 794
        mmWidth = 20000
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
    end
  end
  object ppGroup1: TppGroup
    BreakName = ''Documento do Cliente''
    DataPipeline = plnsView
    GroupFileSettings.NewFile = False
    GroupFileSettings.EmailFile = False
    KeepTogether = True
    OutlineSettings.CreateNode = True
    StartOnOddPage = False
    UserName = ''Group1''
    mmNewColumnThreshold = 0
    mmNewPageThreshold = 0
    DataPipelineName = ''plnsView''
    NewFile = False
    object ppGroupHeaderBand1: TppGroupHeaderBand
      Background.Brush.Style = bsClear
      mmBottomOffset = 0
      mmHeight = 14817
      mmPrintPosition = 0
      object ppLabel3: TppLabel
        UserName = ''lblRazaoSocialCliente''
        Caption = ''Raz''#227''o social: ''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 3387
        mmLeft = 529
        mmTop = 1852
        mmWidth = 18965
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBText4: TppDBText
        UserName = ''dbRazaoSocialCliente''
        DataField = ''Nome do Cliente''
        DataPipeline = plnsView
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = []
        ParentDataPipeline = False
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3175
        mmLeft = 20373
        mmTop = 1852
        mmWidth = 179388
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppLabel5: TppLabel
        UserName = ''lblMes''
        Caption = ''M''#234''s''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 3387
        mmLeft = 529
        mmTop = 10763
        mmWidth = 9525
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppLabel7: TppLabel
        UserName = ''lblValor''
        Caption = ''Valor''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 3387
        mmLeft = 59267
        mmTop = 10848
        mmWidth = 8467
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppLabel8: TppLabel
        UserName = ''lblCNPJCliente''
        Caption = ''CNPJ: ''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 3387
        mmLeft = 529
        mmTop = 5292
        mmWidth = 9313
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBText6: TppDBText
        UserName = ''dbDocumentoCliente''
        DataField = ''Documento do Cliente''
        DataPipeline = plnsView
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = []
        ParentDataPipeline = False
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3175
        mmLeft = 20373
        mmTop = 5292
        mmWidth = 179388
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppLine3: TppLine
        UserName = ''Line1''
        Weight = 0.750000000000000000
        mmHeight = 529
        mmLeft = 265
        mmTop = 14288
        mmWidth = 199761
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppLabel9: TppLabel
        UserName = ''lblIRRF''
        Caption = ''IR retido''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3387
        mmLeft = 114565
        mmTop = 10848
        mmWidth = 20000
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppLabel10: TppLabel
        UserName = ''lblCSLL''
        Caption = ''CSLL retido''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3387
        mmLeft = 136525
        mmTop = 10848
        mmWidth = 20000
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppLabel12: TppLabel
        UserName = ''lblPIS''
        Caption = ''PIS retido''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3387
        mmLeft = 158221
        mmTop = 10848
        mmWidth = 20000
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppLabel15: TppLabel
        UserName = ''lblCOFINS''
        Caption = ''COFINS retido''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3387
        mmLeft = 179652
        mmTop = 10848
        mmWidth = 20000
        BandType = 3
        GroupNo = 0
        LayerName = Foreground
      end
      object ppLabel16: TppLabel
        UserName = ''lblIRRF1''
        Caption = ''INSS retido''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3387
        mmLeft = 97387
        mmTop = 10848
        mmWidth = 15325
        BandType = 3
        GroupNo = 1
        LayerName = Foreground
      end
      object ppLabel17: TppLabel
        UserName = ''Label16''
        Caption = ''ISS retido''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3387
        mmLeft = 78253
        mmTop = 11113
        mmWidth = 13293
        BandType = 3
        GroupNo = 1
        LayerName = Foreground
      end
    end
    object ppGroupFooterBand1: TppGroupFooterBand
      Background.Brush.Style = bsClear
      HideWhenOneDetail = False
      mmBottomOffset = 0
      mmHeight = 4233
      mmPrintPosition = 0
      object ppLabel18: TppLabel
        UserName = ''lblTotalCliente''
        Caption = ''Total Cliente:''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3387
        mmLeft = 14552
        mmTop = 793
        mmWidth = 19050
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppLine5: TppLine
        UserName = ''Line3''
        Weight = 0.750000000000000000
        mmHeight = 265
        mmLeft = 0
        mmTop = 0
        mmWidth = 199761
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc11: TppDBCalc
        UserName = ''dbValorNFSeCliente''
        DataField = ''Valor NFS-e''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup1
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 35454
        mmTop = 793
        mmWidth = 32279
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc12: TppDBCalc
        UserName = ''dbValorIRRFCliente''
        DataField = ''Valor IRRF''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup1
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 114565
        mmTop = 793
        mmWidth = 20000
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc13: TppDBCalc
        UserName = ''dbValorCSLLCliente''
        DataField = ''Valor CSLL''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup1
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 136525
        mmTop = 793
        mmWidth = 20000
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc14: TppDBCalc
        UserName = ''dbValorPISCliente''
        DataField = ''Valor PIS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup1
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 158486
        mmTop = 793
        mmWidth = 20000
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc15: TppDBCalc
        UserName = ''dbValorCOFINSCliente''
        DataField = ''Valor COFINS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup1
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 179652
        mmTop = 793
        mmWidth = 20000
        BandType = 5
        GroupNo = 0
        LayerName = Foreground
      end
      object ppDBCalc23: TppDBCalc
        UserName = ''dbValorIRRFCliente1''
        DataField = ''Valor INSS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup1
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 92604
        mmTop = 794
        mmWidth = 20000
        BandType = 5
        GroupNo = 1
        LayerName = Foreground
      end
      object ppDBCalc26: TppDBCalc
        UserName = ''DBCalc26''
        DataField = ''Valor ISS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = [fsBold]
        ParentDataPipeline = False
        ResetGroup = ppGroup1
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3440
        mmLeft = 69850
        mmTop = 794
        mmWidth = 20000
        BandType = 5
        GroupNo = 1
        LayerName = Foreground
      end
    end
  end
  object ppGroup2: TppGroup
    BreakName = ''N''#250''mero do M''#234''s''
    DataPipeline = plnsView
    GroupFileSettings.NewFile = False
    GroupFileSettings.EmailFile = False
    KeepTogether = True
    OutlineSettings.CreateNode = True
    StartOnOddPage = False
    UserName = ''Group2''
    mmNewColumnThreshold = 0
    mmNewPageThreshold = 0
    DataPipelineName = ''plnsView''
    NewFile = False
    object ppGroupHeaderBand2: TppGroupHeaderBand
      Background.Brush.Style = bsClear
      mmBottomOffset = 0
      mmHeight = 0
      mmPrintPosition = 0
    end
    object ppGroupFooterBand2: TppGroupFooterBand
      Background.Brush.Style = bsClear
      HideWhenOneDetail = False
      mmBottomOffset = 0
      mmHeight = 9260
      mmPrintPosition = 0
      object ppShape3: TppShape
        UserName = ''Zebra''
        Brush.Color = cl3DLight
        ParentHeight = True
        ParentWidth = True
        Pen.Color = clNone
        Pen.Style = psClear
        StretchWithParent = True
        Visible = False
        mmHeight = 9260
        mmLeft = 0
        mmTop = 0
        mmWidth = 200000
        BandType = 5
        GroupNo = 1
        LayerName = Foreground
      end
      object ppDBText7: TppDBText
        UserName = ''dbDescricaoMes''
        DataField = ''Nome do M''#234''s''
        DataPipeline = plnsView
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = []
        ParentDataPipeline = False
        Transparent = True
        WordWrap = True
        DataPipelineName = ''plnsView''
        mmHeight = 7938
        mmLeft = 529
        mmTop = 0
        mmWidth = 35190
        BandType = 5
        GroupNo = 1
        LayerName = Foreground
      end
      object ppDBCalc1: TppDBCalc
        UserName = ''dbValorNFSeMEs''
        DataField = ''Valor NFS-e''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = []
        ParentDataPipeline = False
        ResetGroup = ppGroup2
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3175
        mmLeft = 38629
        mmTop = 0
        mmWidth = 29104
        BandType = 5
        GroupNo = 1
        LayerName = Foreground
      end
      object ppDBCalc2: TppDBCalc
        UserName = ''dbValorPISMes''
        DataField = ''Valor PIS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = []
        ParentDataPipeline = False
        ResetGroup = ppGroup2
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3175
        mmLeft = 158486
        mmTop = 0
        mmWidth = 20000
        BandType = 5
        GroupNo = 1
        LayerName = Foreground
      end
      object ppDBCalc3: TppDBCalc
        UserName = ''dbValorCSLLMes''
        DataField = ''Valor CSLL''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = []
        ParentDataPipeline = False
        ResetGroup = ppGroup2
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3175
        mmLeft = 136525
        mmTop = 0
        mmWidth = 20000
        BandType = 5
        GroupNo = 1
        LayerName = Foreground
      end
      object ppDBCalc4: TppDBCalc
        UserName = ''dbValorIRRFMes''
        DataField = ''Valor IRRF''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = []
        ParentDataPipeline = False
        ResetGroup = ppGroup2
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3175
        mmLeft = 114565
        mmTop = 0
        mmWidth = 20000
        BandType = 5
        GroupNo = 1
        LayerName = Foreground
      end
      object ppDBCalc5: TppDBCalc
        UserName = ''dbValorCOFINSMes''
        DataField = ''Valor COFINS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = []
        ParentDataPipeline = False
        ResetGroup = ppGroup2
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3175
        mmLeft = 179917
        mmTop = 0
        mmWidth = 20000
        BandType = 5
        GroupNo = 1
        LayerName = Foreground
      end
      object ppDBCalc24: TppDBCalc
        UserName = ''dbValorINSSMes''
        DataField = ''Valor INSS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = []
        ParentDataPipeline = False
        ResetGroup = ppGroup2
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3175
        mmLeft = 92604
        mmTop = 0
        mmWidth = 20108
        BandType = 5
        GroupNo = 2
        LayerName = Foreground
      end
      object ppDBCalc25: TppDBCalc
        UserName = ''DBCalc25''
        DataField = ''Valor ISS''
        DataPipeline = plnsView
        DisplayFormat = ''#,0.00;-#,0.00''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = ''Arial''
        Font.Size = 8
        Font.Style = []
        ParentDataPipeline = False
        ResetGroup = ppGroup2
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = ''plnsView''
        mmHeight = 3175
        mmLeft = 69850
        mmTop = 0
        mmWidth = 20108
        BandType = 5
        GroupNo = 2
        LayerName = Foreground
      end
    end
  end
  object raCodeModule2: TraCodeModule
    ProgramStream = {
      01060F5472614576656E7448616E646C65720B50726F6772616D4E616D650611
      4865616465724265666F72655072696E740B50726F6772616D54797065070B74
      7450726F63656475726506536F75726365064670726F63656475726520486561
      6465724265666F72655072696E743B0D0A626567696E0D0A20205A656272612E
      56697369626C65203A3D2046616C73653B0D0A656E643B0D0A0D436F6D706F6E
      656E744E616D650606486561646572094576656E744E616D65060B4265666F72
      655072696E74074576656E74494402180001060F5472614576656E7448616E64
      6C65720B50726F6772616D4E616D65061B47726F7570466F6F74657242616E64
      324265666F72655072696E740B50726F6772616D54797065070B747450726F63
      656475726506536F75726365065C70726F6365647572652047726F7570466F6F
      74657242616E64324265666F72655072696E743B0D0A626567696E0D0A20205A
      656272612E56697369626C65203A3D206E6F74205A656272612E56697369626C
      653B0D0A656E643B0D0A0D436F6D706F6E656E744E616D65061047726F757046
      6F6F74657242616E6432094576656E744E616D65060B4265666F72655072696E
      74074576656E74494402180000}
  end
  object ppDesignLayers1: TppDesignLayers
    object ppDesignLayer1: TppDesignLayer
      UserName = ''Foreground''
      LayerType = ltBanded
      Index = 0
    end
  end
  object ppParameterList3: TppParameterList
  end
end'
,'Retenções por RPS',0,1,4,1,'cdfa16a6-fce2-469f-a263-57a67764fa2b');


delete from nsview.formulariosfiltros where formulariofiltro in ('95ccb82f-2da4-40f4-8901-d99df4609b54','4d4a7469-f451-43dc-97d9-567c6d94c7d4','0e4836c9-4379-4954-88f8-f142b5e4fb31');

INSERT INTO nsview.formulariosfiltros (formulariofiltro, formulario, viewmetadata_id,filtro) VALUES (
'7ef5856c-133b-4f29-851e-8be0dd6ce583','ddb79931-c44c-4f33-8784-575c3bd8dbc5',(select id from nsview.viewsmetadata where view_id in (select id from nsview.views where view_name = 'vw_faturamento_nfse') and column_name = 'Estabelecimento'),'{"m_selecao_unica":"0","m_selecao_multipla":"1"}');

INSERT INTO nsview.formulariosfiltros (formulariofiltro, formulario, viewmetadata_id,filtro) VALUES (
'4d4a7469-f451-43dc-97d9-567c6d94c7d4','ddb79931-c44c-4f33-8784-575c3bd8dbc5',(select id from nsview.viewsmetadata where view_id in (select id from nsview.views where view_name = 'vw_faturamento_nfse') and column_name = 'Data de Emissão'),'{"m_compare_igual":"0","m_compare_maior_que":"0","m_compare_maior_ou_igual":"0","m_compare_menor_que":"0","m_compare_menor_ou_igual":"0","m_compare_intervalo":"-1"}');

INSERT INTO nsview.formulariosfiltros (formulariofiltro, formulario, viewmetadata_id,filtro) VALUES (
'0e4836c9-4379-4954-88f8-f142b5e4fb31','ddb79931-c44c-4f33-8784-575c3bd8dbc5',(select id from nsview.viewsmetadata where view_id in (select id from nsview.views where view_name = 'vw_faturamento_nfse') and column_name = 'Cliente'),'{"m_selecao_unica":"0","m_selecao_multipla":"1"}');
