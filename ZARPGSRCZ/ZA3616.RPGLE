     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Merge XML lines')                             *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  ZA3616 - Merge XML lines                                     *
      *                                                               *
      *  THIS PROGRAM IS COPY OF CG3616                               *
      *                                                               *
      *  Function:  This module merges 2 files.                       *
      *  - CGUXMGPD : group set tags                                  *
      *  - CGUXMRPD : RDE tags                                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR691585           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE040  *CREATE    Date 11Nov03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR691585 - COB failed on SEC4664 (Child: AR691586)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE040 - Securities Statements                               *
      *                                                               *
      *****************************************************************
      /EJECT
     FCGUXMGL1  IF   E           K DISK
     FCGUXMRL1  IF   E           K DISK
     FCGUXMLPD  O    E           K DISK    COMMIT
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      ** Data structures
      ** Informations about RDE s values
     DRdeInfo          DS
     D  DERDEV
     D  DEFMTY
     D  DEFMQL
 
      ** Keys for comparison
     DkGrp             DS
     D  DGITEM
     D  DGINCR
 
     DkRde             DS
     D  DEITEM
     D  DEINCR
 
      ** Working variable
      ** End of file
     DEof_Grp          S              1
     DEof_Rde          S                   LIKE(Eof_Grp)
     DTagValue         S                   LIKE(XMTAGV)
 
      ** Formats tag
     DFormatTag        PR                  LIKE(XMTAGN)
     D  p1                                 VALUE LIKE(DENWRD)
     D  p2                            1  0 VALUE
 
      ** Writes XML statement for Group Set
     DWrtGrsXML        PR                  LIKE(ReturnCode)
     D  p1                                 VALUE LIKE(DGITEM)
     D  p2                                 VALUE LIKE(DGNWGS)
 
      ** Writes XML statement for RDE line
     DWrtRdeXML        PR                  LIKE(ReturnCode)
     D  p1                                 VALUE LIKE(DEITEM)
     D  p2                                 VALUE LIKE(DENWRD)
     D  p3                                 VALUE LIKE(XMTAGV)
 
      ** Formats tag value
     DFmtTagVal        PR                  LIKE(XMTAGV)
     DpRDEInfo                         *   VALUE
 
      ** Converts Midas Run Date to a date
     DMidasDate        PR             8
     D  DayNum                        5  0 VALUE
 
      ** Converts a date to midas run day
     DToMidasDt        PR             5  0
     D  DateIn                        6  0 VALUE
 
      ** Formats a Midas Run day 99999 into an XML date CCYY-MM-DD
     DXMLDate          PR            10
     D  DayA                          5    VALUE
 
      ** Formats a date DDMMYY into an XML date CCYY-MM-DD
     DXMLDate6         PR            10
     D  Date6A                        6    VALUE
 
      ** Formats a date DDMMCCYY into an XML date CCYY-MM-DD
     DXMLDate8         PR            10
     D  Date8A                        8    VALUE
 
      **  Get currency number of decimal position
     DGetDecPos        PR             1  0
     D  Currency                      3    VALUE
 
      ** Format the amount depending the number of decimal positions
     DFmtAmt           PR            16
     D  DecPos                        1  0 VALUE
     D  Amount                       15    VALUE
 
      ** Adjust characters to the right
     DRightAdjust      PR            15
     D  NumberAlph                   15    VALUE
 
     C                   EVAL      ReturnCode = *BLANK
     C                   EVAL      DEITEM = *LOVAL
     C                   EVAL      DGITEM = *LOVAL
     C                   EVAL      DEINCR = 0
     C                   EVAL      DGINCR = 0
 
      ** This process merges 2 files. The resulting records will reflect
      ** the order: ITEM/INCR/(DGNWGS or DENWRD).
      **
      ** For instance for these 2 input files:
      **               File 1             File 2
      **    Key/Value  0001/BEG REFR      0002/FLD1
      **    Key/Value  9999/END REFR      0002/FLD2
      **    key/Value  0003/BEG GRP1      0004/FLD3
      **    key/Value  0005/END GRP1      0004/FLD4
      **
      ** The resulting file is:
      **    Value      BEG REFR
      **    Value      FLD1
      **    Value      FLD2
      **    Value      BEG GRP1
      **    Value      FLD3
      **    Value      FLD4
      **    Value      END GRP1
      **    Value      END REFR
      **
 
     C     KeyGrpSet     SETLL     CGUXMRL1
     C     KeyGrpSet     SETLL     CGUXMGL1
     C                   EXSR      ReadGrp
     C                   EXSR      ReadRde
 
     C                   DOW       (eof_grp = '0' OR eof_rde = '0')
     C                             AND ReturnCode = *BLANK
 
     C                   SELECT
 
      ** Time for the extracted RDE to be processed
     C                   WHEN      (kRde < kGrp OR eof_grp = '1')
     C                             AND eof_rde = '0'
     C                   EVAL      TagValue = FmtTagVal(%ADDR(RdeInfo))
     C                   IF        TagValue = '*ERROR'
     C                   EVAL      ReturnCode =  '*ERROR'
     C                   EVAL      DBFILE = 'TagVal'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = %TRIM(DERDEV) + %TRIM(DEFMTY)
     C                                     + %TRIM(DEFMQL)
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      ReturnCode =
     C                             WrtRdeXML(DEITEM:DENWRD:TagValue)
     C                   EXSR      ReadRde
     C                   ENDIF
     C
      ** Time for the explored Group set to be processed
     C                   WHEN      (kRde > kGrp OR eof_rde = '1')
     C                             AND eof_grp = '0'
     C                   EVAL      ReturnCode
     C                             = WrtGrsXML(DGITEM:DGNWGS)
     C                   EXSR      ReadGrp
      ** Other:
     C                   OTHER
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBFILE = '*LOOP'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = kRde + ' ' + kGrp
     C                   EXSR      *PSSR
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   IF        ReturnCode = *BLANK
     C                   COMMIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON                                              AR691585
     C                   RETURN
      **********************************************************************
      * INITIALISATION SUBROUTINE
      **********************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode       10
 
     C     KeyGrpSet     KLIST
     C                   KFLD                    DGITEM
     C                   KFLD                    DGINCR
 
     C     KeyRDE        KLIST
     C                   KFLD                    DEITEM
     C                   KFLD                    DEINCR
 
     C                   ENDSR
      **********************************************************************
      * READ CGUXMGL1
      **********************************************************************
     C     ReadGrp       BEGSR
     C                   READ      CGUXMGL1
     C                   EVAL      eof_grp = %EOF
     C                   ENDSR
      **********************************************************************
      * READ CGUXMRL1
      **********************************************************************
     C     ReadRde       BEGSR
     C                   READ      CGUXMRL1
     C                   EVAL      eof_rde = %EOF
     C                   ENDSR
     C/COPY ZACPYSRC,PSSR_ILE
      **********************************************************************
      * Formats tag
      * EndTag = 0 xxxxx => <xxxxx>
      * EndTag = 1 xxxxx => </xxxxx>
      **********************************************************************
     PFormatTag        B
     DFormatTag        PI                  LIKE(XMTAGN)
     D  TagName                            VALUE LIKE(DENWRD)
     D  EndTag                        1  0 VALUE
      *
     DTag              S                   LIKE(XMTAGN)
      *
     C                   IF        EndTag = 1
     C                   EVAL      Tag = '</' + %TRIM(TagName) + '>'
     C                   ELSE
     C                   EVAL      Tag = '<' + %TRIM(TagName) + '>'
     C                   ENDIF
     C                   RETURN    Tag
     P                 E
      **********************************************************************
      * Writes XML statement for RDE line
      **********************************************************************
     PWrtRdeXML        B
     DWrtRdeXML        PI                  LIKE(ReturnCode)
     D  Item                               VALUE LIKE(DEITEM)
     D  NewName                            VALUE LIKE(DENWRD)
     D  TagValue                           VALUE LIKE(XMTAGV)
 
     DRetCode          S                   LIKE(ReturnCode)
 
     C                   CLEAR                   CGUXMLD0
     C                   EVAL      XMITEM = Item
     C                   EVAL      XMTAGN = FormatTag(NewName:0)
     C                   EVAL      XMENDT = FormatTag(NewName:1)
     C                   EVAL      XMTAGV = TagValue
     C                   WRITE(E)  CGUXMLD0
     C                   IF        %ERROR
     C                   EVAL      RetCode = '*ERROR'
     C                   ENDIF
 
     C                   RETURN    RetCode
     P                 E
      **********************************************************************
      * Writes XML statement for Group set line
      **********************************************************************
     PWrtGrsXML        B
     DWrtGrsXML        PI                  LIKE(ReturnCode)
     D  Item                               VALUE LIKE(DGITEM)
     D  NewGrp                             VALUE LIKE(DGNWGS)
 
     DRetCode          S                   LIKE(ReturnCode)
 
     C                   CLEAR                   CGUXMLD0
     C                   EVAL      XMITEM = Item
     ** Parameter NewGrp can be either 'xxxxxx' or '/xxxxxx'
     ** We need to extract only 'xxxxxx' character '/' indicates
     ** whether it is a begin or a end tag
     C                   IF        %SUBST(NewGrp:1:1) = '/'
     C                   EVAL      XMTAGN = FormatTag(%SUBST(NewGrp:2):1)
     C                   ELSE
     C                   EVAL      XMTAGN = FormatTag(%SUBST(NewGrp:1:30):0)
     C                   ENDIF
     C                   WRITE(E)  CGUXMLD0
     C                   IF        %ERROR
     C                   EVAL      RetCode = '*ERROR'
     C                   ENDIF
 
     C                   RETURN    RetCode
     P                 E
      **********************************************************************
      * Formats Tag value
      **********************************************************************
     PFmtTagVal        B
     DFmtTagVal        PI                  LIKE(XMTAGV)
     D  pRdeInfo                       *   VALUE
      *
     DTagValue         S                   LIKE(XMTAGV)
     DNbDecPos         S              1  0
     DLen              S              3  0
     DAlphaAmt         S             15
     DDayA             S              5
     DDate6A           S              6
     DDate8A           S              8
      *
     DRdeInfo          DS
     D  RdeValue                           LIKE(DERDEV)
     D  RdeFmtTyp                          LIKE(DEFMTY)
     D  RdeFmtQul                          LIKE(DEFMQL)
      *
     C                   EVAL      RdeInfo = %STR(pRdeINfo)
     C                   SELECT
      ** Midas Day number 99999
     C                   WHEN      RdeFmtTyp = 'MDT'
     C                   EVAL      DayA =  RdeValue
     C                   EVAL      TagValue = XMLDate(DayA)
      ** Date DDMMYY
     C                   WHEN      RdeFmtTyp = 'DMY'
     C                   EVAL      Date6A = RdeValue
     C                   EVAL      TagValue = XMLDate6(Date6A)
      ** Date YYMMDD
     C                   WHEN      RdeFmtTyp = 'YMD'
     C                   EVAL      Date6A = %SUBST(RdeValue:5:2) +
     C                             %SUBST(RdeValue:3:2) +
     C                             %SUBST(RdeValue:1:2)
     C                   EVAL      TagValue = XMLDate6(Date6A)
      ** Date MMDDYY
     C                   WHEN      RdeFmtTyp = 'MDY'
     C                   EVAL      Date6A = %SUBST(RdeValue:3:2) +
     C                             %SUBST(RdeValue:1:2) +
     C                             %SUBST(RdeValue:5:2)
     C                   EVAL      TagValue = XMLDate6(Date6A)
      ** Date DDMMCCYY
     C                   WHEN      RdeFmtTyp = 'DMC'
     C                   EVAL      Date8A = RdeValue
     C                   EVAL      TagValue = XMLDate8(Date8A)
      ** Date MMDDCCYY
     C                   WHEN      RdeFmtTyp = 'MDC'
     C                   EVAL      Date8A = %SUBST(RdeValue:3:2)+
     C                             %SUBST(RdeValue:1:2)+
     C                             %SUBST(RdeValue:5:4)
     C                   EVAL      TagValue = XMLDate8(Date8A)
      ** Amount
     C                   WHEN      RdeFmtTyp = 'AMT'
     C                   EVAL      AlphaAmt = RdeValue
     C                   EVAL      AlphaAmt = RightAdjust(AlphaAmt)
     C                   EVAL      NbDecPos = getDecPos(RdeFmtQul)
     C                   IF        NbDecPos <> -1
     C                   EVAL      TagValue = FmtAmt(NbDecPos:AlphaAmt)
     C                   ELSE
     C                   EVAL      TagValue = '*ERROR'
     C                   ENDIF
      ** Provided no formatting options has been filled the
      ** tag value is mapped with the RDE value otherwise it is
      ** an error. (Unknown formatting option)
     C                   OTHER
     C                   IF        RdeFmtTyp = *BLANK AND RdeFmtQul = *BLANK
     C                   EVAL      TagValue = RdeValue
     C                   ELSE
     C                   EVAL      TagValue = '*ERROR'
     C                   ENDIF
     C                   ENDSL
     C                   RETURN    TagValue
     P                 E
      **********************************************************************
      * Converts Midas Run date
      **********************************************************************
     PMidasDate        B
     DMidasDate        PI             8
     D  DayNum                        5  0 VALUE
 
      *
     DDtDDMMCCYY       DS
     D  DDMMCCYY                      8  0
      *
     DDate             S              8
     DpmRetn           S              1
     DpmDayNum         S              5  0
     DpmDatFmt         S              1
     DpmDate           S              6  0
     DpmData           S              7
     DpmDate8          S              8  0
     DpmDate8F         S              8  0
      *
     C                   CALLB     'ZA0140M'
     C                   PARM                    pmRetn
     C                   PARM      DayNum        pmDayNum
     C                   PARM      'D'           pmDatFmt
     C                   PARM      0             pmDate
     C                   PARM      *BLANK        pmData
     C                   PARM      0             pmDate8
     C     DDMMCCYY      PARM      0             pmDate8F
      *
     C                   IF        pmRetn <> '0'
     C                   EVAL      Date = '*ERROR'
     C                   ELSE
     C                   EVAL      Date = DtDDMMCCYY
     C                   ENDIF
 
     C                   RETURN    Date
     P                 E
      **********************************************************************
      * Converts a date to midas run day
      **********************************************************************
     PToMidasDt        B
     DToMidasDt        PI             5  0
     D  DateIn                        6  0 VALUE
      *
     DpmDATE           S              6  0
     DpmDFMT           S              1
     DpmRTN            S              1
     DpmDAYN           S              5  0
      *
     C                   CALLB     'ZA0270'
     C                   PARM      DateIn        pmDATE            6 0
     C                   PARM      'D'           pmDFMT            1
     C                   PARM      *BLANK        pmRTN             1
     C                   PARM                    pmDAYN            5 0
      *
     C                   IF        pmRTN <> '0'
     C                   EVAL      pmDAYN = -1
     C                   ENDIF
     C                   RETURN    pmDAYN
     P                 E
      **********************************************************************
      * Formats a Midas Run day 99999 into an XML date CCYY-MM-DD
      **********************************************************************
     PXMLDate          B
     DXMLDate          PI            10
     D  DayA                          5    VALUE
      *
     DDIGITS           C                         CONST('0123456789')
     DNotDig           S              3  0
     DDayN             S              5  0
      *
     DDtDDMMCCYY       DS
     D  DDMMCCYY                      8  0
     D  DD                            2    OVERLAY(DDMMCCYY:1)
     D  MM                            2    OVERLAY(DDMMCCYY:3)
     D  CC                            2    OVERLAY(DDMMCCYY:5)
     D  YY                            2    OVERLAY(DDMMCCYY:7)
      *
     DOutDate          S             10
      *
      ** Must be numeric
     C     DIGITS        CHECK     DayA          NotDig
     C                   IF        NotDig = 0
     C                   MOVE      DayA          DayN
     C                   EVAL      DtDDMMCCYY = MidasDate(DayN)
      *
     C                   IF        DtDDMMCCYY = '*ERROR'
     C                   EVAL      OutDate = '*ERROR'
     C                   ELSE
     C                   EVAL      OutDate = CC+YY+'-'+MM+'-'+DD
     C                   ENDIF
     C                   ELSE
     C                   EVAL      OutDate = '*ERROR'
     C                   ENDIF
     C                   RETURN    OutDate
     P                 E
      **********************************************************************
      * Formats a date DDMMYY into an XML date CCYY-MM-DD
      **********************************************************************
     PXMLDate6         B
     DXMLDate6         PI            10
     D  Date6A                        6    VALUE
      *
     DDIGITS           C                         CONST('0123456789')
     DNotDig           S              3  0
     DDate6N           S              6  0
     DOutDate          S             10
      *
     DDayA             DS
     DDayN                            5  0
      *
      ** Date must be numeric
     C     DIGITS        CHECK     Date6A        NotDig
     C                   IF        NotDig = 0
     C                   MOVE      Date6A        Date6N
     C                   EVAL      DayN = ToMidasDt(Date6N)
     C                   IF        DayN = -1
     C                   EVAL      OutDate = '*ERROR'
     C                   ELSE
     C                   EVAL      OutDate = XMLDate(DayA)
     C                   ENDIF
     C                   ELSE
     C                   EVAL      OutDate = '*ERROR'
     C                   ENDIF
     C                   RETURN    OutDate
     P                 E
      **********************************************************************
      * Formats a date DDMMCCYY into an XML date CCYY-MM-DD
      **********************************************************************
     PXMLDate8         B
     DXMLDate8         PI            10
     D  Date8A                        8    VALUE
      *
     DDIGITS           C                         CONST('0123456789')
     DNotDig           S              3  0
     DOutDate          S             10
      *
     DDtDDMMCCYY       DS
     D  DDMMCCYY                      8  0
     D  DD                            2    OVERLAY(DDMMCCYY:1)
     D  MM                            2    OVERLAY(DDMMCCYY:3)
     D  CC                            2    OVERLAY(DDMMCCYY:5)
     D  YY                            2    OVERLAY(DDMMCCYY:7)
      *
     DDate6A           DS
     D  Date6N                        6  0
      *
      ** Date must be numeric
     C     DIGITS        CHECK     Date8A        NotDig
     C                   EVAL      DtDDMMCCYY = Date8A
     C                   IF        NotDig = 0
     C                   EVAL      Date6A = DD+MM+YY
     C                   IF        ToMidasDt(Date6N) = -1
     C                   EVAL      OutDate = '*ERROR'
     C                   ELSE
     C                   EVAL      OutDate = CC+YY+'-'+MM+'-'+DD
     C                   ENDIF
     C                   ELSE
     C                   EVAL      OutDate = '*ERROR'
     C                   ENDIF
     C                   RETURN    OutDate
     P                 E
      **********************************************************************
      * Get currency number of decimal position
      **********************************************************************
     PGetDecPos        B
     DGetDecPos        PI             1  0
     D  Currency                      3    VALUE
      *
     DPmRetn           S              7                                         B:Return code
     DPmOption         S              7                                         I:Option
     DPmCcy            S                   LIKE(Currency)                       I:Key field
     DNbDecPos         S                   LIKE(A6NBDP)                         I:Key field
     DPmFmt          E DS                  EXTNAME(DSSDY)                       S01230
     DSDCURR         E DS                  EXTNAME(SDCURRPD)                    S01230
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PmRetn                         B:Return code
     C                   PARM      '*KEY'        PmOption                       I:Option
     C                   PARM      Currency      PmCcy                          I:Key field
     C     SDCURR        PARM                    PmFmt                          O:Format
      *
     C                   IF        PmRetn = *BLANK                              B:Return code
     C                   EVAL      NbDecPos = A6NBDP                            I:Key field
     C                   ELSE
     C                   EVAL      NbDecPos = -1                                I:Key field
     C                   ENDIF
     C                   RETURN    NbDecPos
      *
     P                 E
      **********************************************************************
      * Format the amount depending the number of decimal positions
      **********************************************************************
     PFmtAmt           B
     DFmtAmt           PI            16
     D  DecPos                        1  0 VALUE
     D  Amount                       15    VALUE
      *
     DDIGITS           C                         CONST(' 0123456789')
     DZfield           S             16
     DOutAmt           S                         LIKE(Zfield)
     DZaDec            S              1  0
     DStart            S              3  0
     DAmtErr           S              3  0
      *
      ** Amount must be numeric
     C     DIGITS        CHECK     Amount        AmtErr
     C                   IF        AmtErr = 0
     C                   MOVE      Amount        Zfield
     C                   CALLB     'ZEDIT'
     C                   PARM                    Zfield
     C                   PARM      DecPos        ZaDec
      *
     C                   IF        Zfield = *BLANK
     C                   EVAL      OutAmt = '*ERROR'
     C                   ELSE
      ** Left adjust the result
     C                   EVAL      OutAmt = Zfield
     C     ' '           CHECK     OutAmt        Start
     C                   EVAL      OutAmt = %SUBST(OutAmt:Start)
     C                   ENDIF
     C                   ELSE
     C                   EVAL      OutAmt = '*ERROR'
     C                   ENDIF
     C                   RETURN    OutAmt
      *
     P                 E
      **********************************************************************
      * Adjust characters to the right
      **********************************************************************
     PRightAdjust      B
     DRightAdjust      PI            15
     D  NumberAlph                   15    VALUE
      *
     DWrkArr           S              1    DIM(15)
     DRightValue       S             15
     Di                S              2  0
     Dj                S              2  0
     Dlen              S              2  0
      *
     C     ' '           CHECKR    NumberAlph    Len
      ** No need to right adjust if the lengh is maximum
     C                   IF        Len = %ELEM(WrkArr)
     C                   EVAL      RightValue = NumberAlph
     C                   ELSE
     C                   MOVEA     NumberAlph    WrkArr
     C                   EVAL      j = %ELEM(WrkArr)
     C                   EVAL      i = Len
     C                   DOW       i >= 1
     C                   EVAL      WrkArr(j) = WrkArr(i)
     C                   EVAL      WrkArr(i) = *BLANK
     C                   EVAL      i = i - 1
     C                   EVAL      j = j - 1
     C                   ENDDO
     C                   MOVEA     WrkArr        RightValue
     C                   ENDIF
      *
     C                   RETURN    RightValue
     P                 E
