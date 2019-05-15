     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Build XML Data')                              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000771 - Midas GL Build XML Data (CRS)                     *
      *                                                               *
      *  Function: This module build XML element from GLNXMLPD        *
      *            file.                                              *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      /EJECT
      ** Midas GL CRS merge XML Data File
     FGLNXMLPD  IF   E             DISK

      ** Midas GL CRS XML Data File
     FGLVXMLPD  O    E             DISK

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
     D Idx             S              5S 0
     D IdxA            S              5S 0 INZ(0)
     D IdxB            S              5S 0 INZ(0)
     D IdxC            S              5S 0 INZ(0)
     D ArrIdx          S              5S 0
     D RtnCode         S              7
     D WkGrpName       S                   LIKE(MRTPMT)
     D WkLevel         S                   LIKE(MRLEVL)
     D WkNameSpace     S                   LIKE(MRNMSP)
     D SvLevelNo       S                   LIKE(MRLEVL)
     D SvLevlNo        S                   LIKE(MRLEVL)
     D SvSeqNo         S                   LIKE(MRSEQU)
     D SvSeqNo2        S                   LIKE(MRSEQU)
     D SvAcctNo        S                   LIKE(MRACNO)
     D SvAcctHo        S                   LIKE(MRACHO)
     D SvNameSp        S                   LIKE(MRNMSP)
     D GroupName       S                   LIKE(MRTPMT)
     D WkGrpLevl       S                   LIKE(MRLEVL)

     D SvGrpLevl       S                   LIKE(MRLEVL) DIM(ArrSize)
     D SvGrpName       S                   LIKE(MRTPMT) DIM(ArrSize)
     D SvGrpLevel      S                   LIKE(MRLEVL) DIM(ArrSize)
     D ArrSize         C                   999
     D WkDataTIN       DS
     D WkTIN                         25    DIM(8)
     D WkDataCOT       DS
     D WkCOT                          2    DIM(8)
     D WkDataRes       DS
     D WkRes                          2    DIM(8)

      *****************************************************************
      /EJECT
      *****************************************************************
      * +------------------------------------------------------------------+
      * ¦ Main Routine                                                     ¦
      * +------------------------------------------------------------------+

     C                   EXSR      SRMainRoutine

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      * +-------------------------------------------------------------+
      * ¦ Subr/SRMainRtn - Process main routine                       ¦
      * +-------------------------------------------------------------+
     C     SRMainRoutine BEGSR


     C     *START        SETLL     GLNXMLPD
     C                   READ      GLNXMLPD
     C                   DOW       NOT %EOF(GLNXMLPD)

     C                   EXSR      SRWrtDetails

     C                   READ      GLNXMLPD
     C                   ENDDO

      ** Write Group End Tag
     C                   EVAL      WkLevel =  0
     C                   EXSR      WrtGrpEndTag

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * +-------------------------------------------------------------+
      * ¦ Subr/SRWrtDetails - Write XML details                       ¦
      * +-------------------------------------------------------------+
     C     SRWrtDetails  BEGSR

     C                   SELECT

     C                   WHEN      MRTLIN = 'R'
     C                   EVAL      GroupName = MRELMT
     C                   EXSR      SrSaveHeader
     C                   EXSR      SRNameTag

     C                   WHEN      MRTLIN = 'Y'
     C                   EVAL      GroupName = MRELMT
     C                   EXSR      WriteGrpTag

     C                   WHEN      MRTLIN = 'N'
     C                   EVAL      GroupName = MRTPMT
     C                   EXSR      WriteGrpTag
     C                   EXSR      SRNameTag

     C                   ENDSL


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * +-------------------------------------------------------------+
      * ¦ Subr/WriteGrpTag - Write Group Tag                          ¦
      * +-------------------------------------------------------------+
     C     WriteGrpTag   BEGSR

     C                   IF        SvLevlNo <> MRLEVL   or
     C                             SvSeqNo  <> MRSEQU   or
     C                             SvAcctNo <> MRACNO   or
     C                             SvAcctHo <> MRACHO

     C                   EVAL      SvLevlNo  = MRLEVL
     C                   EVAL      SvSeqNo   = MRSEQU
     C                   EVAL      SvAcctNo  = MRACNO
     C                   EVAL      SvAcctHo  = MRACHO

      ** Write Group End Tag
     C                   EVAL      WkLevel =  MRLEVL / 100
     C                   EXSR      WrtGrpEndTag

      ** Write Group Tag
     C                   IF        %lookup(MRLEVL:SvGrpLevl) = 0
     C                   EVAL      WkGrpName = GroupName
     C                   EVAL      WkGrpLevl = MRLEVL
     C                   EXSR      WrtGrpTag
     C                   ENDIF

      ** Save Group Tag
     C                   EXSR      SrSaveHeader
     C
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * +-------------------------------------------------------------+
      * ¦ Subr/SaveHeader - Save Group Tag                            ¦
      * +-------------------------------------------------------------+
     C     SrSaveHeader  BEGSR

      ** Save element details on the next avaialbale array index
     C                   EVAL      ArrIdx = %lookup(0:SvGrpLevl)

     C                   IF        %lookup(MRLEVL:SvGrpLevl) = 0

     C                   EVAL      SvGrpLevl(ArrIdx) = MRLEVL
     C                   EVAL      SvGrpName(ArrIdx) = GroupName

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * +-------------------------------------------------------------+
      * ¦ Subr/SRNameTag -  Write Name Tag                            ¦
      * +-------------------------------------------------------------+
     C     SRNameTag     BEGSR

     C                   EVAL      XMSEQN = MRORDR

     C                   IF        MRTLIN = 'R'
     C                   EVAL      XMGRPN = *BLANKS
     C                   EVAL      XMTAGN = MRELMT
     C                   ELSE
     C                   EVAL      XMGRPN = MRTPMT
     C                   EVAL      XMTAGN = MRELMT
     C                   ENDIF

     C                   EVAL      XMLEVL = MRLEVL

     C                   IF        MRELMT = 'TIN'
     C                             OR MRELMT = 'ResCountryCode'

     C                   IF        MRELMT = 'TIN'
     C                   EVAL      WkDataTIN = MRDATA
     C                   EVAL      WkDataCOT = MRDAT2
     C                   EVAL      Idx = 1

     C                   DOW       Idx <= 8
     C                   IF        WkTIN(Idx) <> *BLANKS
     C                   EVAL      XMDATA = WkTIN(Idx)
     C                   EVAL      XMDAT2 = WkCOT(Idx)
     C                   WRITE     GLVXMLD0
     C                   ENDIF
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
     C                   ENDIF

     C                   IF        MRELMT = 'ResCountryCode'
     C                   EVAL      WkDataRes = MRDATA
     C                   EVAL      Idx = 1
     C                   EVAL      MRDAT2 = *Blanks

     C                   DOW       Idx <= 8
     C                   IF        WkRes(Idx) <> *BLANKS
     C                   EVAL      XMDATA = WkRes(Idx)
     C                   WRITE     GLVXMLD0
     C                   ENDIF
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
     C                   ENDIF

     C                   ELSE
     C
     C                   EVAL      XMDATA = MRDATA
     C                   EVAL      XMDAT2 = MRDAT2
     C                   WRITE     GLVXMLD0

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * +-------------------------------------------------------------+
      * ¦ Subr/WrtGrpTag   - Write group tag                          ¦
      * +-------------------------------------------------------------+
     C     WrtGrpTag     BEGSR

     C                   EVAL      XMSEQN = MRORDR
     C                   EVAL      XMGRPN =  WkGrpName
     C                   EVAL      XMTAGN = *BLANKS
     C                   EVAL      XMDATA = *BLANKS
     C                   EVAL      XMDAT2 = *BLANKS
     C                   EVAL      XMLEVL = WkGrpLevl
     C                   WRITE     GLVXMLD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * +-------------------------------------------------------------+
      * ¦ Subr/WrtGrpEndTag - Write remaining group end tag           ¦
      * +-------------------------------------------------------------+
     C     WrtGrpEndTag  BEGSR

     C                   EVAL      Idx = ArrIdx

     C                   DO        ArrIdx
     C                   EVAL      SvLevelNo  = SvGrpLevl (Idx) / 100

     C                   IF        SvLevelNo > WkLevel  OR
     C                             SvLevelNo = WkLevel and MRTLIN = 'Y'

     C                   EVAL      WkGrpName = '/' + SvGrpName (Idx)
     C                   EVAL      WkGrpLevl = SvGrpLevl (Idx)
     C                   EXSR      WrtGrpTag
     C                   EVAL      SvGrpLevl (Idx) = 0
     C                   ENDIF

     C                   EVAL      Idx = Idx - 1

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIALISATION SUBROUTINE
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RtnCode
     C
     C                   ENDSR
      *****************************************************************
