     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Purge Generic Files')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export Module                                   *
      *                                                               *
      *  DEPURGETR - Purge Generic Files                              *
      *                                                               *
      *  Function:  This program will handle the dropping/purging of  *
      *             data from the 'generic' files.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDE005             Date 22Aug02               *
      *                 CDE003             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE004  *CREATE    Date 02Jul01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDE005 - Data Export - Reservation ID (Recompile)            *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  CDE004 - Cross Modular History Extract                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    70         Indicator for subheader for FXDL                *
      *    71         Indicator for subheader for LDNI                *
      *    72         Indicator for subheader for NASP                *
      *    73         Indicator for subheader for SWAP                *
      *    74         Indicator for subheader for CFCO                *
      *    75         Indicator for subheader for FRAS                *
      *    76         Indicator for subheader for FUND                *
      *    77         Indicator for subheader for EXTR                *
      *    78         Indicator for subheader for OTCC                *
      *    79         Indicator for subheader for FEES                *
      *    80         Indicator for subheader for CUSX                *
      *    85         Over Flow Indicator for Printer file            *
      *    86         End of File DEGVALUL1                           *
      *    87         End of File DEGEVNTL1                           *
      *    88         End of File DEGPOSNL1                           *
      *    89         End of File DEGTRANL1                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRAudit    - Subroutine to Output Audit report               *
      *  SREvents   - Process records from Generic Events file        *
      *  SRPosition - Process records for Generic Positions file      *
      *  SRRCFP1    - Register P1 Printer File via RCF                *
      *  SRRCFAU    - Register AU Printer File via RCF                *
      *  SRValue    - Process records from  Generic Valuations Details*
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Generic Transaction Details File
     FDEGTRANL1 UF   E           K DISK    INFSR(*PSSR)

      ** Generic Positions file
     FDEGPOSNL1 UF   E           K DISK    INFSR(*PSSR)

      ** Generic Events File
     FDEGEVNTL1 UF   E           K DISK    INFSR(*PSSR)

      ** Generic Valudations Detail File
     FDEGVALUL1 UF   E           K DISK    INFSR(*PSSR)

     FDEPURGTP1 O    E             PRINTER USROPN INFDS(SPOOL1)
     F                                     OFLIND(*IN85)

     FDEPURGTAU O    E             PRINTER INFDS(SPOOLA)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)


      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)
     D                                     DTAARA(DEEXTCTL)

      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** File Information Data Structure for DEPURGTP1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0

      ** File Information Data Structure for DEPURGTAU
     D SPOOLA          DS
     D  SFILEA                83     92
     D  SFNUMA               123    124B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WkRetDeal       S              4  0
     D WkRetFRA        S              4  0
     D WkRetFndT       S              4  0
     D WkRetFuOp       S              4  0
     D WkRetLenF       S              4  0
     D WkRetRCE        S              4  0

     D @RUN            S              1
     D WNew            S              1
     D WDtls           S              1    INZ(*Blanks)
     D WOpen           S              1    INZ(*Blanks)
     D PTranType       S              4
     D RetDate         S              5  0

     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A

     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZECHAR          S              1
     D ZOUT21          S             21

     D PSeq            S              5A
     D PEnty           S              3A
     D ZSErr           S              1A
     D ZSNUM           S              6  0

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Set the Retention Date

     C                   SELECT
     C                   WHEN      PTranType = 'FXDL' or
     C                             PTranType = 'LDNI' or
     C                             PTranType = 'NASP'
     C     BJRDNB        SUB       WkRetDeal     RetDate
     C                   IF        PTranType = 'FXDL'
     C                   EVAL      *IN70 = *On
     C                   ENDIF
     C                   IF        PTranType = 'LDNI'
     C                   EVAL      *IN71 = *On
     C                   ENDIF
     C                   IF        PTranType = 'NASP'
     C                   EVAL      *IN72 = *On
     C                   ENDIF

     C                   WHEN      PTranType = 'SWAP' or
     C                             PTranType = 'CFCO' or
     C                             PTranType = 'FRAS'
     C     BJRDNB        SUB       WkRetFRA      RetDate
     C                   IF        PTranType = 'SWAP'
     C                   EVAL      *IN73 = *On
     C                   ENDIF
     C                   IF        PTranType = 'CFCO'
     C                   EVAL      *IN74 = *On
     C                   ENDIF
     C                   IF        PTranType = 'FRAS'
     C                   EVAL      *IN75 = *On
     C                   ENDIF

     C                   WHEN      PTranType = 'FUND'
     C     BJRDNB        SUB       WkRetFNDT     RetDate
     C                   EVAL      *IN76 = *On

     C                   WHEN      PTranType = 'EXTR' or
     C                             PTranType = 'OTCC'
     C     BJRDNB        SUB       WkRetFuOp     RetDate
     C                   IF        PTranType = 'EXTR'
     C                   EVAL      *IN77 = *On
     C                   ENDIF
     C                   IF        PTranType = 'OTCC'
     C                   EVAL      *IN78 = *On
     C                   ENDIF

     C                   WHEN      PTranType = 'FEES'
     C     BJRDNB        SUB       WkRetLenF     RetDate
     C                   EVAL      *IN79 = *On

     C                   WHEN      PTranType = 'CUSX'
     C     BJRDNB        SUB       WkRetRCE      RetDate
     C                   EVAL      *IN80 = *On

     C                   ENDSL

      ** Read through the Generic Files

     C     *LOVAL        SETLL     DEGTRANL1
     C                   READ      DEGTRANL1                              89

     C                   DOW       *IN89 = *Off

     C                   MOVEA     '111'         *IN(86)

     C                   IF        T#MDAT <= RetDate
     C                   EVAL      WDtls = 'Y'
     C                   IF        WOpen = *Blanks
     C                   OPEN      DEPURGTP1
     C                   EXSR      SRRCFP1
     C                   EVAL      WOpen = 'Y'
     C                   ENDIF
     C                   EXSR      SRPosition
     C                   EXSR      SREvents
     C                   EXSR      SRValue
     C                   DELETE    DEGTRANL1
     C                   ENDIF

     C                   READ      DEGTRANL1                              89

     C                   IF        *IN89 = *On and WDtls = 'Y'
     C                   WRITE     TRAILER
     C                   CLOSE     DEPURGTP1
     C                   ENDIF

     C                   ENDDO

     C                   IF        WDtls = *Blanks
     C                   EXSR      SRAudit
     C                   ENDIF

     C                   EVAL      *INLR = *ON

      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPosition - Process records for Generic Positions file      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRPosition    BEGSR

     C                   EVAL      WNew = 'Y'
     C     Key1          SETLL     DEGPOSNL1
     C     Key1          READE     DEGPOSNL1                              88

     C                   DOW       *IN88 = *Off
     C                   IF        P#ASLI = 'A'
     C                   EVAL      RPASLI = 'Asset'
     C                   ELSE
     C                   EVAL      RPASLI = 'Liability'
     C                   ENDIF

     C                   EVAL      RPPSTP = P#PSTP

     C                   IF        *IN85 = *ON or RTDRF <> T#TREF
     C                   EVAL      RTDRF = T#TREF
     C                   WRITE     HEADP1
     C                   EVAL      *IN85 = *Off
     C                   ENDIF

     C                   IF        *IN85 = *On or WNew = 'Y'
     C                   WRITE     SUBHD
     C                   EVAL      WNew = *Blanks
     C                   ENDIF

     C                   WRITE     DetPosD

     C                   DELETE    DEGPOSNL1

     C     Key1          READE     DEGPOSNL1                              88
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SREvents - Process records from Generic Events file          *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SREvents      BEGSR

     C                   EVAL      WNew = 'Y'
     C     Key1          SETLL     DEGEVNTL1
     C     Key1          READE     DEGEVNTL1                              87

     C                   DOW       *IN87 = *OFF
     C                   IF        E#ASLI = 'A'
     C                   EVAL      REASLI = 'Asset'
     C                   ELSE
     C                   EVAL      REASLI = 'Liability'
     C                   ENDIF

     C                   MOVE      E#PRSQ        REPRSQ
     C                   EVAL      REEVTP = E#EVTP
     C                   EVAL      REEVRF = E#EVRF

     C                   EVAL      ZDayNo = E#PRDT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate

     C                   IF        ZDate <> *Zero
     C                   MOVEL     ZADate        REPRDT
     C                   ELSE
     C                   EVAL      REPRDT = *Blanks
     C                   ENDIF

     C                   IF        *IN85 = *ON or RTDRF <> E#TREF
     C                   EVAL      RTDRF = E#TREF
     C                   WRITE     HEADP1
     C                   EVAL      *IN85 = *Off
     C                   ENDIF

     C                   IF        *IN85 = *ON or WNew = 'Y'
     C                   WRITE     SUBHD
     C                   EVAL      WNew = *Blanks
     C                   ENDIF

     C                   WRITE     DetEvntD

     C                   DELETE    DEGEVNTL1

     C     Key1          READE     DEGEVNTL1                              87
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRValue - Process records from  Generic Valuations Details   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRValue       BEGSR

     C                   EVAL      WNew = 'Y'
     C     Key1          SETLL     DEGVALUL1
     C     Key1          READE     DEGVALUL1                              86

     C                   DOW       *IN86 = *Off

     C                   EVAL      ZDayNo = V#VLDT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate

     C                   IF        ZDate <> *Zero
     C                   MOVEL     ZADate        RVVLDT
     C                   ELSE
     C                   EVAL      RVVLDT = *Blanks
     C                   ENDIF

     C                   MOVE      V#MKVL        ZFLD15
     C                   Z-ADD     T#VCDP        ZDECS
     C                   EVAL      ZOUT21 = *Blanks
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21

     C                   EVAL      RVMKVL = ZOUT21

     C                   IF        *IN85 = *ON or RTDRF <> V#TREF
     C                   EVAL      RTDRF = V#TREF
     C                   WRITE     HEADP1
     C                   EVAL      *IN85 = *OFF
     C                   ENDIF

     C                   IF        *IN85 = *ON or WNew = 'Y'
     C                   WRITE     SUBHD
     C                   EVAL      WNew = *Blanks
     C                   ENDIF

     C                   WRITE     DetVald

     C                   DELETE    DEGVALUL1

     C     Key1          READE     DEGVALUL1                              86
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCF - Subroutine to register the P1 Printer File via RCF   *
      *                                                               *
      *  Called By: *INZSR                                            *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************

     C     SRRCFP1       BEGSR

      ** Ensure Report Spool File recorded by RCF.

     C                   Z-ADD     SFNUM1        ZSNUM

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       PEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *Blanks       ZSErr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCF - Subroutine to register the P1 Printer File via RCF   *
      *                                                               *
      *  Called By: *INZSR                                            *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************

     C     SRRCFAU       BEGSR

      ** Ensure Report Spool File recorded by RCF.

     C                   Z-ADD     SFNUMA        ZSNUM

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       PEnty
     C                   PARM                    SFILEA
     C                   PARM                    ZSNUM
     C                   PARM      *Blanks       ZSErr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output Audit report                  *
      *                                                               *
      *  Called By: *INZSR, Main Processing                           *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR

      ** Output Report Header and File Controls.

     C                   WRITE     HEADAU

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *On
     C                   WRITE     DBERROR
     C                   ELSE

      ** Or, if no records read, Output "No Details" message.

     C                   IF        WDtls = *Blanks
     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST

     C                   PARM                    PTranType

      ** Access Bank details file

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        ReturnCode <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = @Optn
     C                   EXSR      *PSSR
     C                   END

      ** Access data area

     C     *LOCK         IN        DEEXTCTL
     C                   EVAL      WkRetDeal = DEPDDL
     C                   EVAL      WkRetFRA  = DEPDFR
     C                   EVAL      WkRetFndT = DEPDFT
     C                   EVAL      WkRetFuOp = DEPDFF
     C                   EVAL      WkRetLenF = DEPDLF
     C                   EVAL      WKRetRCE  = DEPDCE
     C                   OUT       DEEXTCTL

     C                   EXSR      SRRCFAU

     C     Key1          KLIST
     C                   KFLD                    T#MOD
     C                   KFLD                    T#TREF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   EXSR      SRAudit
     C                   CALL      'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      ********************************************************************
