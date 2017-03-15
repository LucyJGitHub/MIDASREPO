     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Build XML Data')                              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000668 - Midas GL Build XML Data                           *
      *                                                               *
      *  Function: This module build XML element from GLRMDTPD        *
      *            file.                                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL154 - FATCA Reporting                                     *
      *                                                               *
      *****************************************************************
      /EJECT
     FGLRMDTL6  IF   E           K DISK
     FGLFXMLL0  IF   E           K DISK
     FGLUXMLPD  O    E             DISK

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

      ** Working variable
     D RtnCode         S              7
     D ActCode         S              7
     D PMessageID      S             21
     D WkSeqn          S                   LIKE(XMSEQN)
     D WkFirst         S              1    INZ('Y')
     D WkGrpName       S                   LIKE(XMGRPN)
     D WkElemName      S                   LIKE(XMELMT)
     D WkLevel         S                   LIKE(XMLEVL)
     D Idx             S              5S 0
     D IdxA            S              5S 0
     D IdxB            S              5S 0
     D IdxC            S              5S 0
     D ArrIdx          S              5S 0
     D SvLevelNo       S                   LIKE(XMLEVL)
     D SvElemName      S                   LIKE(XMELMT)
     D SvSeqNo         S                   LIKE(XMORDR)
     D SvGroupNm       S                   LIKE(XMGRPN)
     D KLevelNo        S                   LIKE(MGLEVL)
     D KElemName       S                   LIKE(MGELMT)
     D KGrpName        S                   LIKE(MGTPMT)
     D WkTopInd        S              1
     D WFirst          S              1

     D SvGrpName       S                   LIKE(XMGRPN) DIM(ArrSize)
     D SvGrpLevl       S                   LIKE(XMLEVL) DIM(ArrSize)
     D SvNameSpace     S                   LIKE(XMNMSP) DIM(ArrSize)
     D ArrSize         C                   500

      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Main Routine                                                     ¦
      * +------------------------------------------------------------------+

     C                   EXSR      SRMainRoutine

     C                   EXSR      WrtGrpEndTag
     C
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/SRMainRtn - Process main routine                       ¦
      * +-------------------------------------------------------------+
     C     SRMainRoutine BEGSR

     C     *LOVAL        SETLL     GLFXMLL0
     C                   READ      GLFXMLL0
     C                   DOW       NOT %EOF(GLFXMLL0)

     C                   SELECT

     C                   WHEN      XMREPR = 'N'
     C                   EXSR      SRNonRepFlds

     C                   WHEN      XMTLIN = 'Y'

     C                   ENDSL

     C                   READ      GLFXMLL0
     C                   ENDDO

     C                   ENDSR
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/SRNonRepFlds - Process none repeating fields           ¦
      * +-------------------------------------------------------------+
     C     SRNonRepFlds  BEGSR

     C                   SELECT
     C                   WHEN      XMTLIN = 'Y'
     C                   EXSR      SRHeader

     C                   WHEN      XMTLIN = 'N'
     C                   EXSR      CrtDtlData

     C                   WHEN      XMTLIN = 'R'
     C                   EXSR      CrtDtlData
     C                   EXSR      SaveHeader

     C                   ENDSL

     C                   ENDSR
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/CrtDtlData - Create XML data from GLRMDTPD file        ¦
      * +-------------------------------------------------------------+
     C     CrtDtlData    BEGSR


     C                   EVAL      KLevelNo  = XMLEVL
     C                   EVAL      KElemName = XMELMT
     C     KGroupName    SETLL     GLRMDTL6
     C                   READ      GLRMDTL6
     C                   DOW       NOT %EOF(GLRMDTL6) and
     C                             PMessageId = MGMSID and
     C                             KLevelNo  = MGLEVL and
     C                             KElemName = MGELMT

     C                   EXSR      SRNameTag

     C                   READ      GLRMDTL6
     C                   ENDDO

     C
     C                   ENDSR
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/SRHeader - Write Group Tag                             ¦
      * +-------------------------------------------------------------+
     C     SRHeader      BEGSR

     C                   EVAL      WkLevel =  XMLEVL / 100
     C                   EVAL      Idx = ArrIdx
     C                   DO        ArrIdx
     C                   IF        SvGrpLevl (Idx) >= WkLevel and
     C                             SvGrpLevl (Idx) <> 0
     C                   EVAL      WkGrpName = '/' + %TRIM(SvNameSpace(ArrIdx))
     C                                             + SvGrpName (Idx)
     C                   EXSR      WrtGrpTag
     C                   EVAL      SvGrpLevl (Idx) = 0
     C                   ENDIF
     C                   EVAL      Idx = Idx - 1
     C                   ENDDO

     C                   EXSR      SaveHeader
     C
     C                   EVAL      WkGrpName = %TRIM(XMNMSP) +XMELMT
     C                   EXSR      WrtGrpTag
     C
     C                   ENDSR
      * +-------------------------------------------------------------+
      * ¦ Subr/SaveHeader - Save Group Tag                            ¦
      * +-------------------------------------------------------------+
     C     SaveHeader    BEGSR

     C                   EVAL      ArrIdx = ArrIdx + 1
     C                   EVAL      SvGrpLevl(ArrIdx) = XMLEVL / 100
     C                   EVAL      SvGrpName(ArrIdx) = XMELMT
     C                   EVAL      SvNameSpace(ArrIdx) = XMNMSP

     C                   ENDSR
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/SRNameTag -  Write Name Tag                            ¦
      * +-------------------------------------------------------------+
     C     SRNameTag     BEGSR

     C                   EVAL      XMSEQN = XMORDR

     C                   IF        XMTLIN = 'R'
     C                   EVAL      XMGRPN = *BLANKS
     C                   EVAL      XMTAGN = %TRIM(XMNMSP) + MGELMT
     C                   ELSE
     C                   EVAL      XMGRPN = %TRIM(XMNMSP) + MGTPMT
     C                   EVAL      XMTAGN = %TRIM(XMNMSP) + MGELMT
     C                   ENDIF

     C                   EVAL      XMDATA = MGDATA
     C                   EVAL      XMDAT2 = MGDAT2
     C                   WRITE     GLUXMLD0

     C                   ENDSR
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WrtGrpTagR  - Write group tag (Repeating fields)       ¦
      * +-------------------------------------------------------------+
     C     WrtGrpTagR    BEGSR

     C                   EVAL      XMGRPN =  WkGrpName
     C                   EVAL      XMTAGN = *BLANKS
     C                   EVAL      XMDATA = *BLANKS
     C                   EVAL      XMDAT2 = *BLANKS
     C                   WRITE     GLUXMLD0

     C                   ENDSR
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WrtGrpTag   - Write group tag                          ¦
      * +-------------------------------------------------------------+
     C     WrtGrpTag     BEGSR

     C                   EVAL      XMSEQN = XMORDR
     C                   EVAL      XMGRPN =  WkGrpName
     C                   EVAL      XMTAGN = *BLANKS
     C                   EVAL      XMDATA = *BLANKS
     C                   EVAL      XMDAT2 = *BLANKS
     C                   WRITE     GLUXMLD0

     C                   ENDSR
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WrtGrpEndTag - Write remaining group end tag           ¦
      * +-------------------------------------------------------------+
     C     WrtGrpEndTag  BEGSR

     C                   EVAL      Idx = ArrIdx
     C                   DO        ArrIdx
     C                   IF        SvGrpLevl (Idx) <> 0
     C                   EVAL      WkGrpName = '/' + %TRIM(SvNameSpace(ArrIdx))
     C                                             + SvGrpName (Idx)
     C                   EXSR      WrtGrpTag
     C                   EVAL      SvGrpLevl (Idx) = 0
     C                   ENDIF
     C                   EVAL      Idx = Idx - 1
     C                   ENDDO

     C                   ENDSR
      /EJECT
      **********************************************************************
      * INITIALISATION SUBROUTINE
      **********************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PMessageID
     C                   PARM                    RtnCode

     C     KGroupName    KLIST
     C                   KFLD                    PMessageId
     C                   KFLD                    KLevelNo
     C                   KFLD                    KElemName

     C                   ENDSR
      **********************************************************************
