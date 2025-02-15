     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD056751
/*STD *  RPGSQLMOD                                                    *                     MD056751
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD056751
/*EXI *  TEXT('Midas GL XML Stream File Generator program')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000769 - XML Stream File Generator program (CRS)           *
      *                                                               *
      *  Function: This module creates a stream file (type *STMF)     *
      *  and writes compressed XML data (from PF/GLCRMDPD) to it.     *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD048427           Date 20Jan22               *
      *  Prev Amend No. MD056751           Date 20Sep20               *
      *                 CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD048427 - CGL177 Incorrect amounts in CRS XML file          *
      *  MD056751 - Deliverable Data Split for GLFXMLPD and GLGXMLPD  *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      /EJECT

     FGLVXMLPD  IF   E             DISK
      ** Midas GL CRS XML Schema
     F*GLGXMLL2* IF   E           K DISK                                                    MD056751

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
     D XMTAGN
     D XMDATA
     D XMDAT2
     D*XMFLDA***                                                                            MD056751
     D XXFLDA                         3                                                     MD056751

     D GLGXML        E DS                  EXTNAME(GLGXMJW0)                                MD056751
      ** Working variable
     DPTagName         S                   LIKE(XMTAGN)
     DPTagValue        S                   LIKE(XMDATA)
     DPTagValue2       S                   LIKE(XMDAT2)
     DPTagEnd          S                   LIKE(XMTAGN)
     DPNamSpace        S                   LIKE(XMNMSP)
     DPFormat          S                   LIKE(XMFLDA)
     D FDescDat        S             10I 0
     D RtnCode         S              7
     D ActCode         S              7
     D ActionCd        S              7
     D TagName         S                   LIKE(XMTAGN)
     D KLevel          S                   LIKE(XMLEVL)
     D*KElemNm**       S                   LIKE(XMTAGN)                                     MD056751
     D KElemNm         S             40                                                     MD056751

      ** Formats tag
     DFormatTag        PR                  LIKE(XMTAGN)
     D  p1                                 VALUE LIKE(XMTAGN)
     D  p2                            1  0 VALUE
     D  p3                                 VALUE LIKE(XMNMSP)

      ** Formats tag value
     DFmtTagVal        PR                  LIKE(XMDATA)
     DpRDEInfo                         *   VALUE

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
      /EJECT
      * +------------------------------------------------------------------+
      * � Main Routine                                                     �
      * +------------------------------------------------------------------+

      ** Create/Open the Streamfile
     C                   EXSR      CreateSTMF

      ** Write the Streamfile from array element
     C                   EXSR      WriteSTMF

      ** Close the Streamfile .DAT
     C                   EXSR      CloseSTMF
     C
     C                   EVAL      *INLR = *ON
     C                   RETURN

      * +-------------------------------------------------------------+
      * � Subr/CreateSTMF - Create streamfile (type *STMF) in         �
      * �                   exclusive mode.                           �
      * +-------------------------------------------------------------+
     C     CreateSTMF    BEGSR

     C                   CALL      'GL000770'
     C                   PARM      '*CREATE'     ActCode
     C                   PARM      *BLANKS       PTagName
     C                   PARM      *BLANKS       PTagValue
     C                   PARM      *BLANKS       PTagValue2
     C                   PARM      *BLANKS       PTagEnd
     C                   PARM      *BLANKS       PFormat
     C                   PARM      *BLANKS       RtnCode

     C                   IF        RtnCode <> *BLANKS
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      /EJECT
      * +-------------------------------------------------------------+
      * � Subr/WriteSTMF - Write XML details                          �
      * �                  into the stream file.                      �
      * +-------------------------------------------------------------+
     C     WriteSTMF     BEGSR

     C     1             SETLL     GLVXMLPD
     C                   READ      GLVXMLPD
     C                   DOW       NOT %EOF(GLVXMLPD)

     C                   EVAL      PTagName = *BLANKS
     C                   EVAL      PTagValue = *BLANKS
     C                   EVAL      PTagEnd = *BLANKS
     C
     C                   EXSR      GetNmSpace

     C                   IF        XMTAGN  = *BLANKS

     C                   EVAL      PTagValue = XMDATA
     C                   IF        %SUBST(XMGRPN:1:1) = '/'
     C                   EVAL      PTagName = %SUBST(XMGRPN:2)
     C                   EVAL      PTagName = FormatTag(PTagName:1:PNamSpace)
     C                   ELSE
     C                   EVAL      PTagName = XMGRPN
     C                   EVAL      PTagName
     C                             =FormatTag(%SUBST(PTagName:1:40):0:PNamSpace)
     C                   ENDIF

     C                   ELSE

     C                   EVAL      PTagValue = FmtTagVal(%ADDR(RdeInfo))
     C                   IF        PTagValue = '*ERROR'
     C                   EVAL      ReturnCode =  '*ERROR'
     C                   EVAL      DBFILE = 'TagVal'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = %TRIM(XMTAGN) + %TRIM(XMDATA)
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      TagName = XMTAGN
     C                   EVAL      PTagName = FormatTag(TagName:0:PNamSpace)
     C                   EVAL      PTagEnd  = FormatTag(TagName:1:PNamSpace)
     C                   EVAL      PTagValue2 = XMDAT2
     C                   ENDIF
     C                   ENDIF

     C                   CALL      'GL000770'
     C                   PARM      '*WRITE'      ActCode
     C                   PARM                    PTagName
     C                   PARM                    PTagValue
     C                   PARM                    PTagValue2
     C                   PARM                    PTagEnd
     C                   PARM      XMFLDA        PFormat
     C                   PARM      *BLANKS       RtnCode

     C                   READ      GLVXMLPD
     C                   ENDDO

     C                   ENDSR
      /EJECT
      * +-------------------------------------------------------------+
      * � Subr/GetNmSpace - Get Name Space                            �
      * +-------------------------------------------------------------+
     C     GetNmSpace    BEGSR

     C                   IF        XMTAGN  <> *BLANKS
     C                   EVAL      KElemNm = XMTAGN
     C                   ELSE
     C                   EVAL      KElemNm = XMGRPN
     C                   IF        %SUBST(XMGRPN:1:1) = '/'
     C                   EVAL      KElemNm = %SUBST(XMGRPN:2:39)
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      KLevel  = XMLEVL
     C*****KGrpLevel     CHAIN     GLGXMLL2                                                 MD056751
     C/EXEC SQL                                                                             MD056751
     C+ SELECT *                                                                            MD056751
     C+ into :GLGXML                                                                        MD056751
     C+ from GLGXMJW0                                                                       MD056751
     C+ where XMLEVL = :KLevel   and XMELMT = :KElemNm                                      MD056751
     C/END-EXEC                                                                             MD056751
     C**********         IF        %FOUND(GLGXMLL2)                                         MD056751
     C                   IF        SQLCODE = 0                                              MD056751
     C                   EVAL      PNamSpace = XMNMSP
     C                   ELSE
     C                   EVAL      PNamSpace = *BLANKS
     C                   ENDIF

     C                   ENDSR
      /EJECT
      * +-------------------------------------------------------------+
      * � Subr/CloseSTMF - Close the stream file using  IFS API       �
      * �                  CLOSE()function.                           �
      * +-------------------------------------------------------------+
     C     CloseSTMF     BEGSR

     C                   CALL      'GL000770'
     C                   PARM      '*CLOSE'      ActCode
     C                   PARM      *BLANKS       PTagName
     C                   PARM      *BLANKS       PTagValue
     C                   PARM      *BLANKS       PTagValue2
     C                   PARM      *BLANKS       PTagEnd
     C                   PARM      *BLANKS       PFormat
     C                   PARM      *BLANKS       RtnCode

     C                   IF        RtnCode <> *BLANKS
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
      * INITIALISATION SUBROUTINE
      *****************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    RtnCode

     C     KGrpLevel     KLIST
     C                   KFLD                    KLevel
     C                   KFLD                    KElemNm

     C                   ENDSR
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      * Formats tag
      * EndTag = 0 xxxxx => <xxxxx>
      * EndTag = 1 xxxxx => </xxxxx>
      *****************************************************************
     PFormatTag        B
     DFormatTag        PI                  LIKE(PTagName)
     D  TagName                            VALUE LIKE(PTagName)
     D  EndTag                        1  0 VALUE
     D  NameSpace                          VALUE LIKE(PNamSpace)

     DTag              S                   LIKE(PTagName)

     C                   IF        EndTag = 1
     C                   EVAL      Tag = '</' + %TRIM(NameSpace)
     C                                        + %TRIM(TagName) + '>'
     C                   ELSE
     C                   EVAL      Tag = '<' + %TRIM(NameSpace)
     C                                       + %TRIM(TagName) + '>'
     C                   ENDIF
     C                   RETURN    Tag
     P                 E
      **********************************************************************
      * Formats Tag value
      **********************************************************************
     PFmtTagVal        B
     DFmtTagVal        PI                  LIKE(PTagValue)
     D  pRdeInfo                       *   VALUE

     DTagValue         S                   LIKE(PTagValue)
     DNbDecPos         S              1  0
     DLen              S              3  0
     DAlphaAmt         S             15
     DDayA             S              5
     DDate6A           S              6
     DDate8A           S              8
     DAmtSign          S              1

     DRdeInfo          DS
     D  RdeElement                         LIKE(XMTAGN)
     D  RdeValue                           LIKE(XMDATA)
     D  RdeValue2                          LIKE(XMDAT2)
     D  RdeFmtQul                          LIKE(XMFLDA)

     C                   EVAL      RdeInfo = %STR(pRdeINfo)

     C                   SELECT

     C                   WHEN      RdeFmtQul = 'AMT'
     C                             and RdeValue  <> *BLANKS
     C                   EVAL      AmtSign   = *BLANKS
     C                   IF        %SUBST(RdeValue:1:1) = '-'
     C                   EVAL      RdeValue  = %SUBST(RdeValue:2:199)
     C                   EVAL      AmtSign   = '-'
     C                   ENDIF
     C                   EVAL      AlphaAmt = RdeValue
     C                   EVAL      AlphaAmt = RightAdjust(AlphaAmt)
     C                   IF        RdeValue2 = *BLANKS
     C                   EVAL      NbDecPos = 0
     C                   ELSE
     C                   EVAL      NbDecPos = getDecPos(RdeValue2)
     C                   ENDIF
     C                   IF        NbDecPos <> -1
     C                   EVAL      TagValue = FmtAmt(NbDecPos:AlphaAmt)
     C                   EVAL      TagValue = %TRIM(AmtSign) + TagValue
     C                   ELSE
     C                   EVAL      TagValue = '*ERROR'
     C                   ENDIF

     C                   WHEN      RdeFmtQul = 'YMD'
     C                   IF        RdeValue <> *BLANKS
     C                   EVAL      TagValue = %SUBST(RdeValue:1:4) + '-' +
     C                                        %SUBST(RdeValue:5:2) + '-' +
     C                                        %SUBST(RdeValue:7:2)
     C                   ELSE
     C                   EVAL      TagValue = *BLANKS
     C                   ENDIF

     C                   OTHER
     C                   EVAL      TagValue = RdeValue

     C                   ENDSL

     C                   RETURN    TagValue
     P                 E
      **********************************************************************
      * Get currency number of decimal position
      **********************************************************************
     PGetDecPos        B
     DGetDecPos        PI             1  0
     D  Currency                      3    VALUE

     DPmRetn           S              7
     DPmOption         S              7
     DPmCcy            S                   LIKE(Currency)
     DNbDecPos         S                   LIKE(A6NBDP)
     DPmFmt          E DS                  EXTNAME(DSSDY)
     DSDCURR         E DS                  EXTNAME(SDCURRPD)

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PmRetn
     C                   PARM      '*KEY'        PmOption
     C                   PARM      Currency      PmCcy
     C     SDCURR        PARM                    PmFmt

     C                   IF        PmRetn = *BLANK
     C                   EVAL      NbDecPos = A6NBDP
     C                   ELSE
     C                   EVAL      NbDecPos = -1
     C                   ENDIF
     C                   RETURN    NbDecPos

     P                 E
      **********************************************************************
      * Format the amount depending the number of decimal positions
      **********************************************************************
     PFmtAmt           B
     DFmtAmt           PI            16
     D  DecPos                        1  0 VALUE
     D  Amount                       15    VALUE

     DDIGITS           C                         CONST(' 0123456789')
     DZfield           S             16
     DOutAmt           S                         LIKE(Zfield)
     DZaDec            S              1  0
     DStart            S              3  0
     DAmtErr           S              3  0

     DZAfld            S              1    DIM(15)                                     MD048427
     DIdZA             S              2P 0                                             MD048427
      *                                                                                MD048427
      ** Amount must be numeric
     C                   EVAL      AmtErr = %CHECK(DIGITS:Amount)
     C                   IF        AmtErr = 0
      ** Replace Blanks with zeroes.                                                   MD048427
     C                   MOVEA     '  '          ZAfld                                 MD048427
     C                   MOVEA     Amount        ZAfld                                 MD048427
     C                   Z-ADD     1             IdZA                                  MD048427
     C     ZAfld(IdZA)   DOWEQ     '  '                                                MD048427
     C     IdZA          ANDLE     15                                                  MD048427
     C                   MOVE      '0'           ZAfld(IdZA)                           MD048427
     C                   ADD       1             IdZA                                  MD048427
     C                   ENDDO                                                         MD048427
     C                   MOVEA     ZAfld         Amount                                MD048427
     C**********         MOVE      Amount        Zfield                                MD048427
     C                   MOVE      Amount        Zfield                                MD048427
     C                   CALLB     'ZEDIT'
     C                   PARM                    Zfield
     C                   PARM      DecPos        ZaDec

     C                   IF        Zfield = *BLANK
     C                   EVAL      OutAmt = '*ERROR'
     C                   ELSE

      ** Left adjust the result
     C                   EVAL      OutAmt = Zfield
     C                   EVAL      Start = %CHECK(' ':OutAmt)
     C                   EVAL      OutAmt = %SUBST(OutAmt:Start)
     C                   ENDIF
     C                   ELSE
     C                   EVAL      OutAmt = '*ERROR'
     C                   ENDIF
     C                   RETURN    OutAmt

     P                 E
      *****************************************************************
      * Adjust characters to the right
      *****************************************************************
     PRightAdjust      B
     DRightAdjust      PI            15
     D  NumberAlph                   15    VALUE

     DWrkArr           S              1    DIM(15)
     DRightValue       S             15
     Di                S              2  0
     Dj                S              2  0
     Dlen              S              2  0

     C                   EVAL      Len = %CHECKR(' ':NumberAlph)

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

     C                   RETURN    RightValue
     P                 E
