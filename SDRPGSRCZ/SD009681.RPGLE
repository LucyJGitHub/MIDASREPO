     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate Number of Decimal Places')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009681 - Validate number of Decimal Places                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG22002           Date 20Jan09               *
      *                 CER044  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22002 - When a value w/o decimal places is entered,       *
      *             system rejects value and issues error message     *
      *  CER044 - German Features LF035-00 AWV Reporting              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR   - Initialisation Subroutine                         *
      *  SRPRoc   - Validate Processing le                            *
      *  SRValDec - Validate number of Decimal Places                 *
      *  SRError  - Error in Program Sub-Routine                      *
      *  *PSSR    - Error processing                                  *
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
      *
      ** Midas SD Currency codes retrieval
      *
     FSDCURRL1  IP   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D SystemValData   DS           200
     D  SysValMinAmt           1     16
      *
     D AmtArr          S              1a   DIM(16)
     D MsgIDXArr       S              7a   DIM(99)
     D SystemValue     S             20a
     D ProcMode        S            190a
     D GenError        S              1a
     D Idx             S              2p 0
     D WDotPos         S              2s 0
     D WLastPos        S              2s 0
     D WPosDIF         S              2s 0
     D WDec            S              2s 0
     D TmpValMinAmt    S             15a
     D TmpValMinAmt1   S             30a
     D TmpValMinAmtX   S             15a
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      **
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      **
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      * First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
     d
      ** Currency Code
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Array Use to Check numbers
      *
     d                 DS
     d $Nums                         10    Inz('1234567890')
     d $Numeric                       1    Dim(10) Overlay($Nums)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter Variables to call 'AOSVALR0'
      *
     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal1          S            200A
     D PSVal2          S            200A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A
      *
      ** Other work variable
      *
     D PRtcd           S              7A
     D WRun            S              1A
     D WNbrCnt         S              6  0
     D WForCnt         S              6  0
     D WDlCnt          S              6  0
     D WElCnt          S              6  0
     D WReCnt          S              6  0
     D POptn           S              7A
     D RCcY            S              3A
     D WCcY1           S              3A
     D WCcY2           S              3A
      *
     d VdecPos         s              2s 0
     d WdecPos         s              2s 0
     d WblkPos         s              2s 0
     d W1stChr         s             15a
     d W2ndChr         s             15a
     D TmpValMinAmtN   S             15s 0
     d vArrVar         s              1
     d vCtr            s              2s 0
     d vOccur          s              2s 0
     d vLen            s              2s 0
     d v1char          s              1
     D vIdx            S              2p 0
      *
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
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Main Processing
      *
     c                   IF        PSVal1         = *Blanks
 
     c                   EVAL      GenError = 'Y'
     c                   EVAL      Idx  = Idx + 1
     c                   EVAL      MsgIDXArr(Idx) = 'USR0738'
     c                   EVAL      *INLR = *ON
     c                   RETURN
 
     c                   Else
 
     c                   EXSR      SRPRoc
     c
     c                   ENDIF
      *
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRoc - Validate Processing                                  *
      *                                                               *
      * Called By: Main Processing                                    *
      *                                                               *
      * Calls: SRValDec                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRPRoc        BEGSR
      *
     c** Load Value to Array
      *
     c                   EXSR      SRLoadArray
      *
      ** Check for the Number of .Dot Occurence
      *
     c                   EXSR      SRDotOccur
 
     c                   EVAL      VdecPos = vOccur
 
     c                   IF        VdecPos > 1
     c                   EVAL      GenError = 'Y'
     c                   EVAL      Idx  = Idx + 1
     c                   EVAL      MsgIDXArr(Idx) = 'USR8275'
     c                   EVAL      *INLR = *ON
     c                   RETURN
     c
     c                   Else
 
     c                   IF        VdecPos = 1
     c
     c                   EVAL      TmpValMinAmt  = %Trim(SysValMinAmt)
     ** Remove '.' Dot
      *
     c                   EVAL      WdecPos = %Scan('.':TmpValMinAmt)
     c                   EVAL      WblkPos = %Scan(' ':TmpValMinAmt) - 1
     c                   EVAL      W1stChr = %Subst(TmpValMinAmt:1:WdecPos - 1)
 
     c                   EVAL      WblkPos = WblkPos - WdecPos
     c                   EVAL      WdecPos = WdecPos + 1
     c                   EVAL      W2ndChr =%Subst(TmpValMinAmt:WdecPos:WblkPos)
     c
     c                   EVAL      TmpValMinAmt = %Trim(W1stChr) +
     c                                            %Trim(W2ndChr)
     c                   MOVE      TmpValMinAmt  TmpValMinAmtN
      *
     c     ' ':'0'       XLATE     TmpValMinAmt  TmpValMinAmt
     c                   TESTN                   TmpValMinAmt         21
     c     1             DO        15            x                 2 0
     c                   Eval      v1char = %subst(TmpValMinAmt:x:1)
     c                   EVAL      *in21 = *OFF
     c     v1char        LOOKUP    $Numeric                               71
     c                   IF        NOT %FOUND
     c                   EVAL      *In21 = *ON
     c                   LEAVE
     c                   ENDIF
     c                   ENDDO
      *
     c                   IF        *in21  = *on
     c                   EVAL      GenError = 'Y'
     c                   EVAL      Idx  = Idx + 1
     c                   EVAL      MsgIDXArr(Idx) = 'USR0822'
     c                   EVAL      *INLR = *ON
     c                   RETURN
     c                   ENDIF
     c                   IF        *in21 = *off anD
     c                             TmpValMinAmtN > 0
     c                   EVAL      WdotPos  = %Scan('.':SysValMinAmt)
     c                   EVAL      WLastPos = %Scan(' ':SysValMinAmt) - 1
     c                   EVAL      WPosDIF  = WLastPos - WdotPos
     c                   EVAL      WDec     = WPosDIF
     c                   EXSR      SRValDec
     c
     c                   ENDIF
     c                   ENDIF
     c
     c                   IF        VdecPos = 0
     c
     c                   EVAL      TmpValMinAmt  = %Trim(SysValMinAmt)
      *
     c                   EVAL      WdecPos = %Scan('.':TmpValMinAmt)
     c                   EVAL      WblkPos = %Scan(' ':TmpValMinAmt) - 1
     c                   EVAL      W1stChr = %Subst(TmpValMinAmt:1:WblkPos)
 
     c                   EVAL      TmpValMinAmt = %Trim(W1stChr)
     c                   MOVE      TmpValMinAmt  TmpValMinAmtN
      *
     c     ' ':'0'       XLATE     TmpValMinAmt  TmpValMinAmt
     c                   TESTN                   TmpValMinAmt         22
     c     1             DO        15            x                 2 0
     c                   Eval      v1char = %subst(TmpValMinAmt:x:1)
     c                   EVAL      *in22 = *OFF
     c     v1char        Lookup    $Numeric                               71
     c                   IF        NOT %FOUND
     c                   EVAL      *In22 = *ON
     c                   LEAVE
     c                   ENDIF
     c                   ENDDO
      *
     c                   IF        *in22  = *on
     c                   EVAL      GenError = 'Y'
     c                   EVAL      Idx  = Idx + 1
     c                   EVAL      MsgIDXArr(Idx) = 'USR0822'
     c                   EVAL      *INLR = *ON
     c                   RETURN
     c                   ENDIF
     c
     c                   IF        *in22 = *off anD
     c                             TmpValMinAmtN > 0
     c                   EVAL      WDec     = 0
     c                   EXSR      SRValDec
     c
     c                   ENDIF
     c                   ENDIF
 
     c                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValDec - Validate number of Decimal Places                  *
      *                                                               *
      * Called By: SRPRoc                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRValDec      BEGSR
      *
     c                   MOVE      PsVal1        RCcY
     c
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      PsVal1        RCcY
     c     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtcd = ' '  anD
     C**********                   WDec   <> A6NBDP                                         BUG22002
     C                             WDec   > A6NBDP                                          BUG22002
     c                   EVAL      GenError = 'Y'
     c                   EVAL      Idx  = Idx + 1
     c                   EVAL      MsgIDXArr(Idx) = 'USR8276'
     c                   EVAL      *INLR = *ON
     c                   RETURN
     C                   ENDIF
     C
     C                   IF        PRtcd =  '*NRF'
     c                   EVAL      GenError = 'Y'
     c                   EVAL      Idx  = Idx + 1
     c                   EVAL      MsgIDXArr(Idx) = 'USR9524'
     c                   EVAL      *INLR = *ON
     c                   RETURN
     C                   ENDIF
      *
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * SRLoadArray - Populate Array                                   *
      *                                                               *
      * Called By: -  SRPRoc                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     c     SRLoadArray   BEGSR
 
     c                   EVAL      vArrVar = ' '
     c                   EVAL      vIdx     = 1
 
     c                   EVAL      SysValMinAmt = %TrimL(SysValMinAmt)
     c                   EVAL      TmpValMinAmt =  SysValMinAmt
 
     c                   DOW       %Subst(SysValMinAmt:vIdx:1) <> *blanks
     c                   EVAL      vArrVar = %Subst(SysValMinAmt:vIdx:1)
     c                   MOVE      vArrVar       AmtArr(vIdx)
     c                   EVAL      vIdx    = vIdx + 1
     c                   ENDDO
 
     c                   ENDSR
      *****************************************************************
      *****************************************************************
      *                                                               *
      * SRDotOccur - Check for .Dot Occurence                         *
      *                                                               *
      * Called By: -  SRPRoc                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     c     SRDotOccur    BegSr
 
     c                   EVAL      vArrVar = ' '
     c                   EVAL      vCtr    = 1
     c                   EVAL      vOccur = 0
 
     c                   DOW       %Subst(SysValMinAmt:vCtr:1) <> *blanks
     c                   EVAL      vArrVar = %Subst(SysValMinAmt:vCtr:1)
     c                   IF        vArrVar = '.'
     c                   EVAL      vOccur = vOccur + 1
     c                   ENDIF
     c                   EVAL      vCtr    = vCtr + 1
     c                   Enddo
 
     c                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR       - Program Initialisation routine                *
      *                                                               *
      *  Called by:   - Implicitly on program activation              *
      *                                                               *
      *  Calls: None  -                                               *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      'RptgCcy'     PSValK1
     C                   PARM                    PSVal1
     C                   PARM      *BLANKS       PSValK2
     C                   PARM                    PSVal2
     C                   PARM      *BLANKS       PSValK3
     C                   PARM                    PSVal3
     C                   PARM      *BLANKS       PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Intialise working fields
      *
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPROC = *BLANKS
      *
      ** Define the *Entry parameter list with the following parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    SystemValue
     C                   PARM                    SystemValData
     C                   PARM                    ProcMode
     c                   PARM                    GenError
     C                   PARM                    Idx
     C                   PARM                    MsgIDXArr
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR  - Program exception error routine                         *
      *           Called automatically IF a program error occurs,         *
      *           or directly by the program code using EXSR.             *
      *           This subroutine DUMPs the program just once.            *
      *                                                                   *
      *  Called by: (**calling routines**)                                *
      *                                                                   *
      *  Calls: None                                                      *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
     C                   EVAL      GenError = 'Y'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
