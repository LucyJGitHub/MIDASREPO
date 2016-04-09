     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD IGA Country Update Subfile')                  *
      *****************************************************************
      *  Includes MD024724                                            *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000136 - Midas SD IGA Country Update Subfile               *
      *                                                               *
      *  Function:  This program display the records from the Midas   *
      *             Country Codes File where the FATCA Agreement Type *
      *             has changed                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    05 - Refresh                                               *
      *    30 - Subfile Display                                       *
      *    31 - Subfile Clear                                         *
      *    32 - Subfile Message End                                   *
      *    36 - Subfile End                                           *
      *    80 - No Data To Display                                    *
      *    98 - Rollup Indicator                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *  SRBldSfl  - Build the Subfile                                *
      *  SRLoadSfl - Load the Subfile                                 *
      *  SRDspSfl  - Display the Subfile                              *
      *  SRPrSfl   - Process the Subfile Functions                    *
      *  SRReset   - Reset the Fields                                 *
      *  SRClrSfl  - Clear the Subfile                                *
      *  SRErrDta  - Output Error Message With Data                   *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *    The *INZSR Subroutine Will Only Get Called Automatically   *
      *    On Entry To The Module The First Time It Is Run            *
      *    (Unless You End The Program With LR On).  Similarly        *
      *    D-spec Initialisation Only Happens The First Time.  Use    *
      *    RESET For Subsequent Passes.                               *
      *                                                               *
      *****************************************************************
      *---------------------------------------------------------------*
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ** Country Codes File
     FSDCTRYL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** IGA Country Update Subfile
     FSD000136DFCF   E             WORKSTN
     F                                     SFILE(SD000136S0:RRN0 )
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically Included D-Specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The Following /COPY Line Includes The LDA Layout,
      ** And The Following Named Constants:
      **    True       Logical = *ON (For Indcator Processing)
      **    False      Logical = *OFF (For Indcator Processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (The Name Of The Database
      **                         Error Handler)
      ** And The Following Variables:
      **    RunBefore  1A (For The PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The Following /COPY Line Includes All The Defined Fields In
      ** the PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End Of Automatically Included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Arrays And Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS For Access Program, Shrot Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** External DS Based On SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** DS For Indicators
     D Indicators      DS                  BASED(Ind_Pointer)
     D  Exit                  03     03
     D  Refresh               05     05
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflMsgEnd             32     32
     D  SflEnd                36     36
     D  NoData                80     80
     D  Rollup                98     98
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Ind_Pointer     S               *   INZ(%ADDR(*IN))
     D POpt            S              1A
     D RRN0            S              4S 0
     D WLstRrn         S              4S 0
     D WSelectCN       S              1A
     D WSelectCF       S              1A
     D WCtr            S              2  0
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D SflPag          C                   CONST(14)
      *
      ** Parameter For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenCNNM        S              3P 0
     D PLenD0CNNM      S              3P 0
     D PLenFAAT        S              3P 0
     D PLenD0FAAT      S              3P 0
     D PTranslate      S              1A   INZ('1')
     D PTrim           S              1A   INZ('1')
     D PWild           S              1A   INZ('?')
     D PResult         S              3P 0
      *
      ** Parameter For ZA0350
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A
      *
      ** Variable Declaration
     D PRetCode        S              3A
     D WRun            S              1A
     D WIdx            S              3P 0
     D WCcd            S                   LIKE(D0CNCDS)
     D WCnm            S                   LIKE(D0CNNMS)
     D WFat            S                   LIKE(D0FAATS)
      *
      ** Selected Countries
     D PCArr           S           1000A
      ** Selected Countries Array
     D SelCtryArr      S              2    Dim(500)
     D X               S              3  0
      *
      ** +--------------------------------------+
      ** ¦ End Of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      **+--- Start of Main Processing --------------------------------+
      **|                                                             ¦
      **¦ Initial Processing Is Performed Automatically: The *INZSR   ¦
      **¦ Is Executed At Program Activation.                          ¦
      **¦                                                             ¦
      **+-------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN - Processing                                             *
      *****************************************************************
      *
      ** Build the Subfile
     C                   EXSR      SRBldSfl
      *
      ** Display the Screen Until F3 Is Pressed
     C                   DOW       (Exit = *OFF)
      *
      ** Display And Process the Subfile
     C                   EXSR      SRDspSfl
      *
      ** Process the Subfile
     C                   EXSR      SRProcess
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly On Program Activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Call The Access Object AOBANKR0
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Populate WorkStation ID
     C                   EVAL      D0WOID = PsJobName
      *
      ** Populate User
     C                   EVAL      D0USRP = PsUser
      *
      ** Populate Midas Run Date
     C                   EVAl      D0MRDT = BJMRDT
      *
      ** Initialise Subfile Program Queue and Message File
     C                   EVAL      D1PGMQ = '*'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
      *
      ** Message Subfile Indicator
     C                   EVAL      SflMsgEnd = *ON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *                                                               *
      *  Called by: MAIN Processing, SRProcess                        *
      *                                                               *
      *  Calls: SRClrSfl, SRLoadSfl                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSfl      BEGSR
      *
      ** Clear the Subfile
     C                   EXSR      SRClrSfl
      *
      ** Load the Subfile
     C                   EXSR      SRLoadSfl
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspSfl - Display the Subfile                               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDspSfl      BEGSR
      *
     C                   TIME                    D0TIME
      *
      ** Write the Footer
     C                   WRITE     SD000136F0
      *
      ** Write the Message Subfile Control Format
     C                   WRITE     SD000136C1
      *
      ** Display the Subfile
     C                   EXFMT     SD000136C0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRReset, SRBldSfl, SRLoadSfl, SRPrSfl                 *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
      ** Reset the Fields and The Program Message Queue
     C                   EXSR      SRReset
      *
     C                   IF        D0CNCDS = *BLANKS
     C                   EVAL      WCcd = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0CNNMS = *BLANKS
     C                   EVAL      WCnm = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0FAATS = *BLANKS
     C                   EVAL      WFat = *BLANKS
     C                   ENDIF
      *
     C                   SELECT
      *
      ** When F3 Is Pressed
     C                   WHEN      Exit = *ON
     C                   LEAVESR
      *
      ** When F5 Is Pressed
     C                   WHEN      Refresh = *ON
      *
      ** Reset And Build
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
      *
      ** When Page Down Is Pressed
     C                   WHEN      Rollup = *ON
      *
      ** Load the Next Page
     C                   EXSR      SRLoadSfl
      *
      ** When Selection Filters Are Not Changed
     C
     C                   WHEN      (D0CNCDS = WCcd) AND
     C                             (D0CNNMS = WCnm) AND
     C                             (D0FAATS = WFat)
      *
      ** Process the Function Keys And the Values Entered On the
      ** Screen
     C                   EXSR      SRPrSfl
      *
      ** At least one country must be selected
     C                   IF        SelCtryArr(1) = *BLANKS AND
     C                             *IN34 <> '1'
     C                   EVAL      PMSGID = 'USS0284'
     C                   EVAL      WIdx = WIdx +1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Call the 2nd screen
     C                   IF        SelCtryArr(1) <> *BLANKS
     C                   MOVEA     SelCtryArr    PCArr
      *
     C                   CALL      'SD000113'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PCArr
      *
      ** When F3 Is Pressed Go To Main Menu
     C                   IF        PRtcd = 'F3'
     C                   EVAL      Exit = *ON
     C                   LEAVESR
     C                   ENDIF
      *
      ** Build the Subfile Along With the New Records Added
     C                   EXSR      SRBldSfl
     C                   ENDIF
      *
      ** When Selection Filters Are Entered
     C                   WHEN      (D0CNCDS <> *BLANKS) OR
     C                             (D0CNNMS <> *BLANKS) OR
     C                             (D0FAATS <> *BLANKS)
      *
     C                   EXSR      SRPrSfl
      *
     C                   EVAL      WCcd = D0CNCDS
     C                   EVAL      WCnm = D0CNNMS
     C                   EVAL      WFat = D0FAATS
      *
      ** Build the Subfile With the Selection Criteria (Filters)
     C                   EXSR      SRBldSfl
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset - Reset the Fields                                   *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
      *
      ** Clear Program Queue And Message File
     C                   CALL      'ZA0250'
      *
     C                   EVAL      WIdx = 0
      *
     C                   IF        Refresh = *ON
      *
      ** Reset Selection Fields
     C                   EVAL      D0CNCDS = *BLANKS
     C                   EVAL      D0CNNMS = *BLANKS
     C                   EVAL      D0FAATS = *BLANKS
     C                   EVAL      WCcd = *BLANKS
     C                   EVAL      WCnm = *BLANKS
     C                   EVAL      WFat = *BLANKS
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSfl - Clear The SubFile                                 *
      *                                                               *
      *  Called by: SRBldSfl                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRClrSfl      BEGSR
      *
      ** Set Pointer To First Record Of Database
     C     *LOVAL        SETLL     SDCTRYL0
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      D0ACTN = *BLANKS
     C                   EVAL      SelCtryArr = *BLANKS
     C                   EVAL      X=1
     C                   EVAL      NoData = *OFF
     C                   EVAL      SflClr = *ON
      *
     C                   WRITE     SD000136C0
      *
     C                   EVAL      SflClr = *OFF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSfl - Load the Subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl,SRProcess                                *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRLoadSfl     BEGSR
     C                   EVAL      WSelectCN = 'Y'
     C                   EVAL      WSelectCF = 'Y'
      *
      ** If Relative Record Number Of The Last Record Loaded In The
      ** Subfile Is Greater Than Zero
      *
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
     C                   ENDIF
      *
      ** Set the Pointer To the Entered Country Code
     C                   IF        (D0CNCDS <> *BLANKS) AND
     C                             (Rollup = *OFF) AND
     C                             NOT %EOF(SDCTRYL0)
     C     D0CNCDS       SETLL     SDCTRYL0
     C                   ENDIF
      *
      ** Reset Counter
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(SDCTRYL0)
      *
      ** Read the Country Codes File
     C                   READ      SDCTRYL0
      *
     C                   IF        %EOF(SDCTRYL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(SDCTRYL0)
     C                   EVAL      D0CNCD = A4CNCD
     C                   EVAL      D0CNNM = A4CNNM
     C                   EVAL      D0FAAT = A4FAAT
      *
      ** Country Name Filter Is Not Blanks
     C                   IF        D0CNNMS <> *BLANKS
     C                   EVAL      PLenCNNM = %LEN(A4CNNM)
     C                   EVAL      PLenD0CNNM = %LEN(D0CNNMS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    A4CNNM
     C                   PARM                    PLenCNNM
     C                   PARM                    PStart
     C                   PARM                    D0CNNMS
     C                   PARM                    PLenD0CNNM
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectCN = 'N'
     C                   EVAL      D0CNNM = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectCN = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** FATCA Agreement Type Filter Is Not Blanks
     C                   IF        D0FAATS <> *BLANKS
     C                   EVAL      PLenFAAT = %LEN(A4FAAT)
     C                   EVAL      PLenD0FAAT = %LEN(D0FAATS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    A4FAAT
     C                   PARM                    PLenFAAT
     C                   PARM                    PStart
     C                   PARM                    D0FAATS
     C                   PARM                    PLenD0FAAT
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectCF = 'N'
     C                   EVAL      D0FAAT = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectCF = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write the Selected Records
     C                   IF        WSelectCN = 'Y' AND
     C                             WSelectCF = 'Y' AND
     C                             A4FAAT <> 'UKN'
      *
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      D0ACTN = *BLANKS
     C                   WRITE     SD000136S0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check For Last Record For Switching On the SFLEND Indicator
     C                   READ      SDCTRYL0
     C                   IF        %EOF(SDCTRYL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     SDCTRYL0
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
      *
      ** Check If Records Are Written Into Subfile
     C                   IF        WLstRrn <> 0
     C                   EVAL      SflDsp = *ON
     C                   ELSE
      *
      ** If No Records Exists, Then Show 'No Data to Display' Message
     C                   EVAL      SflDsp = *OFF
     C                   EVAL      NoData = *ON
     C                   EVAL      PMsgId = 'ASM0001'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrSfl - Process the Subfile Functions                      *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRPrSfl       BEGSR
      *
      ** Check For Last Relative Record Number
     C                   IF        WLstRrn > *ZEROS
      *
     C                   IF        D0CNCDS <> WCcd OR
     C                             D0CNNMS <> WCnm OR
     C                             D0FAATS <> WFat
     C                   LEAVESR
     C                   ENDIF
      *
     C                   READC     SD000136S0
     C                   EVAL      *IN34 = *OFF
     C                   DOW       NOT %EOF
      *
      ** Save Selected Country Codes Into An Array To Be Passed Into
      ** The Tool
     C                   IF        D0ACTN <> *BLANKS
     C                   IF        D0ACTN <> 'X'
     C     RRN0          CHAIN     SD000136S0
     C                   EVAL      D0ACTN = 'X'
     C                   EVAL      *IN34 = *ON
     C                   UPDATE    SD000136S0
     C                   ELSE
     C                   EVAL      SelCtryArr(X) = D0CNCD
     C                   EVAL      X=X+1
     C                   EVAL      *IN34 = *OFF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READC     SD000136S0
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by: SRProcess, SRLoadSfl                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRErrDta      BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      D0CNCD        PMsgData
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANKS
      *
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
