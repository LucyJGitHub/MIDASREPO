     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Maintain Exchange Rate Spread Codes')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000322  - FEES AND CHARGES: EXCHANGE RATE SPREAD           *
      *              MAINTENANCE                                      *
      *                                                               *
      *  Function:  This program allows the input, review and         *
      *             maintenance of Exchange Rate Spreads.  This       *
      *             allows the bank to make exchange rates on FT      *
      *             transactions more/less favourable depending on    *
      *             whether STP is used.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG433             Date 02Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 09Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTXTRHPD                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFT000322DFCF   E             WORKSTN
     F                                     SFILE(FT000322SA:@RRNA)
     F                                     SFILE(FT000322SB:@RRNB)
 
      * FT Exchange Rate Parent : Read
     FFTXTRHL0  iF   E           K DISK    Rename(FTXTRHD0:EXREAD)
 
      * FT Exchange Rate Parent : Update
     FFTXTRHL1  UF A E           K DISK    Infds(XtDs) InFsr(XtSr)
 
      * FT Exchange Rate Parent Codes Only
     FFTXTRHL2  IF A E           K DISK    RENAME(FTXTRHD0:ParentO)
 
      * FT Exchange Rate Child (Key = Spread Code, Currency)
     FFTXTRDL0  UF A E           K DISK    INFDS(YtDs) INFSR(YtSr)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *       KC  Exit                                                *
      *       KI  Add record                                          *
      *       KJ  Confirm                                             *
      *       KL  Previous                                            *
      *                                                               *
      *       10  Error in Selection (subfile A)                      *
      *       11  Error in Parent Spread Code                         *
      *       12  Error in Selection (subfile B)                      *
      *       13  Error in Currency                                   *
      *       14  Error in Buy Spread % - Manual                      *
      *       15  Error in Buy Spread Points - Manual                 *
      *       16  Error in Buy Spread Sign - Manual                   *
      *       17  Error in Sell Spread % - Manual                     *
      *       18  Error in Sell Spread Points - Manual                *
      *       19  Error in Sell Spread Sign - Manual                  *
      *       20  Error in Buy Spread % - STP                         *
      *       21  Error in Buy Spread Points - STP                    *
      *       22  Error in Buy Spread Sign - STP                      *
      *       23  Error in Sell Spread % - STP                        *
      *       24  Error in Sell Spread Points - STP                   *
      *       25  Error in Sell Spread Sign - STP                     *
      *       26  Error in Exchange Rate Spread Code                  *
      *       27  Error in Exchange Rate Spread Description           *
      *                                                               *
      *       30  Action is insert or amend                           *
      *                                                               *
      *       70  Protect all Screen 2 fields                         *
      *       71  Enable Selection field                              *
      *       72  Protect S2SPRDCD (during Amend)                     *
      *       73  Enable 'F10 = Confirm' feature                      *
      *       74  Protect Currency on Subfile 'B'                     *
      *                                                               *
      *       80  CHAIN indicator                                     *
      *       81  READC indicator                                     *
      *       82  LOOKUP indicator                                    *
      *                                                               *
      *       87  ROLLUP (Subfile B)                                  *
      *       88  SFLCLR (Subfile B)                                  *
      *       89  SFLEND (Subfile B)                                  *
      *       90  SFLDSP (Subfile B)                                  *
      *       91  SFLNXTCHG (Subfile B)                               *
      *       92  SFLDSP (Subfile A)                                  *
      *       93  SFLEND (Message subfile)                            *
      *       94  SFLDSPCTL (Message subfile)                         *
      *       95  SFLNXTCHG (Subfile A)                               *
      *       96  SFLEND (Subfile A) / READ FTXTRHL0                  *
      *       97  SFLCLR (Subfile A)                                  *
      *       98  ROLLUP (Subfile A)                                  *
      *                                                               *
      *       99  General READ/READE indicator                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** No. of decimal places in Spread % and Spread Points fields
     D SpreadDecs      C                   8
 
      ** No. of digits in Spread % and Spread Points fields
     D SpreadDigits    C                   5
 
     D Record_Locked   C                   Const(01218)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array to hold currencies from Subfile 'B'
     D SflCcyArr       S              3    DIM(50)
 
      ** Array to hold currencies already defined on FTXTRDPD
     D FileCcyArr      S              3    DIM(50)
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for general ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Subfile 'B' fields
     D SubfileBRec     DS
     D  S2SEL
     D  S2XRSCCY
     D  S2MANBPC
     D  S2MANBSP
     D  S2MANBSN
     D  S2STPBPC
     D  S2STPBSP
     D  S2STPBSN
     D  S2MANSPC
     D  S2MANSSP
     D  S2MANSSN
     D  S2STPSPC
     D  S2STPSSP
     D  S2STPSSN
 
     D XtDS            DS
     D  XtStatus         *Status
 
     D YtDS            DS
     D  YtStatus         *Status
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error array index
     D I               S              3P 0
 
      ** Currency array index
     D Y               S              2P 0
 
      ** No of selections made from First screen
     D SelCount_A      S              3  0
 
      ** Flag controlling Main Processing
     D Control         S              1    INZ('A')
 
      ** Action Code sent from Screen 1 to Screen 2
     D S2Action        S              1
 
      ** Exchange Rate Spread Code used for building Subfile 'B'
     D KeySprCode      S                   LIKE(SPRCOD)
 
      ** Parameter for call to FT000950
     D ParmSPRCOD      S                   LIKE(SPRCOD)
 
      ** Work fields used by ZALIGN and ZEDIT
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
     D WorkNumField    S                   LIKE(MANBPC)
 
     D XtLocked        S              1
     D ReturnPt        S              6
     D YtLocked        S              1
 
      * Work field for Euro currency
     D  EuroCcy        S                   Like(BKEURO)
 
      * Work field for base currency as an 'IN' currency
     D  BaseCcyIN      S                   Like(A6INCY)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialise First screen
     C                   IF        Control = 'A'
     C                             and XTLOCKED <> 'Y'
     C                             and YTLOCKED <> 'Y'
     C                   EXSR      Init_A
     C                   ELSE
     C                   EVAL      XTLOCKED = 'N'
     C                   EVAL      YTLOCKED = 'N'
     C                   ENDIF
      *
      ** Process First screen
     C                   DOW       Control = 'A'
     C                   EXSR      Screen_A
     C                   ENDDO
      *
      ** Initialise Second screen
     C                   IF        Control = 'B'
     C                   EXSR      Init_B
     C                   ENDIF
      *
      ** Process Second screen
     C                   DOW       Control = 'B'
     C                   EXSR      Screen_B
     C                   ENDDO
      *
      ** Update files
     C                   IF        Control = 'U'
      *
     C                   SELECT
     C                   WHEN      S2Action = 'I'
     C                   EXSR      ProcInsert
     C                   EVAL      Control = 'B'
      *
     C                   WHEN      S2Action = 'A'
     C                   EXSR      ProcAmend
     C                   EVAL      Control = 'B'
      *
     C                   WHEN      S2Action = 'D'
     C                   EXSR      ProcDelete
     C                   EVAL      Control = 'A'
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** Terminate program
     C                   IF        Control = 'X'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
      **********************************************************************
      /EJECT
      **********************************************************************
      * Init_A - Initialise Second Screen                                  *
      **********************************************************************
     C     Init_A        BEGSR
      *
      * Clear message subfile, screen fields and error flags
     C                   EVAL      *IN95 = *Off
     C                   EVAL      S1POSNTO = *Blanks
      *
      **  Write the First Screen footer
     C                   WRITE     FT000322FA
      *
      **  Clear subfile A (first screen)
     C                   EXSR      ClearSfl_A
      *
      **  Position pointer at first record and build first subfile page
     C     *LOVAL        SETLL     FTXTRHL0
     C                   READ      FTXTRHL0                               96
      *
     C                   EXSR      LoadSfl_A
      *
     C                   EVAL      Control = 'A'
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * Screen_A - Display and process First screen
      ********************************************************************
     C     Screen_A      BEGSR
      *
      **  Write the message subfile
     C                   WRITE     FT000322M0
      *
      **  Display screen
     C                   WRITE     FT000322CA
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
     C                   READ      FT000322CA                             99
      *
     C                   SELECT
      *
      **  If F3, bypass further processing
     C                   WHEN      *INKC = *On
     C                   MOVEL     'X'           Control
      *
      **  If F9, go to Second screen with all fields blank and input-capable
     C                   WHEN      *INKI = *On
     C                   EVAL      Control = 'B'
     C                   EVAL      S2Action = 'I'
      *
      **  If ROLLUP (*IN98) - build next subfile page.  If there has been
      **  an error in subfile selection, do not allow rollup.
     C                   WHEN      *IN98 = *On
     C                   ExSr      ResetErrs_A
     C                   Move      'Y'           Roll              1
     C                   EXSR      LoadSfl_A
      *
      **  Otherwise Enter has been pressed - validate subfile selection or
      **  process 'Position To'
     C                   OTHER
     C                   EXSR      ResetErrs_A
     C                   IF        SflCount_A > 0
     C                   EXSR      ReadSfl_A
     C                   ENDIF
      *
      ** If no errors, process subfile action code
     C                   IF        I = 0
     C                   IF        S2Action <> *Blanks
     C                   EVAL      Control = 'B'
      *
      ** If no selection made display subfile page according to 'position
      ** to' Exchange Spread Code
     C                   ELSE
     C                   EXSR      ClearSfl_A
     C     S1POSNTO      SETLL     FTXTRHL0
     C                   READ      FTXTRHL0                               96
     C                   EXSR      LoadSfl_A
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Process error messages
     C                   EXSR      ProcErrs
      *
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * LoadSfl_A - Load Subfile 'A' page
      ********************************************************************
     C     LoadSfl_A     BEGSR
      *
      **  Restore the subfile relative record number, if rollup has been
      **  pressed.
 
     C                   If        Roll = 'Y'
     C                   Eval      @RRNA = Saved_RRN
     C                   Eval      Roll = 'N'
     C                   EndIf
 
      **  Initialise work fields
     C                   Z-ADD     0             SflCount_A        3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
     C                   DOW       *IN96 = *Off  and  SflCount_A < 12
      *
      **  If record selected for output, increment the subfile record
      **  number and records written fields.
     C                   ADD       1             @RRNA
     C                   ADD       1             SflCount_A
      *
      ** Format RFT detail fields for output
     C                   EXSR      FmtParentFlds
      *
      **  Write the record to the subfile
     C                   MOVE      *BLANK        S1SEL
     C                   Z-ADD     @RRNA         S1SFRN
     C                   WRITE     FT000322SA
      *
      ** Read next record
     C                   READ      FTXTRHL0                               96
      *
     C                   ENDDO
 
      **  Save the subfile relative record number
 
     C                   Z-Add     0             Saved_RRN         4 0
     C                   Eval      Saved_RRN = @RRNA
 
      *
      **  If no records exist set up an error message and deactivate SFLDSP.
      **  Also write the footer record format - this blanks existing subfile
      **  records.
     C                   IF        SflCount_A = 0
     C                   ADD       1             I
     C                   MOVE      'Dummy'       FldNameArr(I)
     C                   MOVE      'GEN0001'     MsgIdArr(I)
     C                   EVAL      *IN92 = *Off
     C                   WRITE     FT000322FA
     C                   ELSE
     C                   EVAL      *IN92 = *On
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      * ReadSfl_A - Read Subfile A record
      ********************************************************************
     C     ReadSfl_A     BEGSR
      *
      **  Read Subfile 'A' for selections
     C                   READC     FT000322SA                             81
     C                   DOW       *IN81 = *Off
      *
     C                   IF        S1SEL <> *Blanks
     C                   EVAL      *IN95 = *On
     C                   ADD       1             SelCount_A
      *
      **  Validate selection if entered
     C                   IF        S1SEL <> 'A'  and  S1SEL <> 'E' and
     C                             S1SEL <> 'D'
     C                   EVAL      *IN10 = *On
     C                   EVAL      S1SFRN = @RRNA
     C                   ADD       1             I
     C                   MOVE      'S1SEL'       FldNameArr(I)
     C                   MOVE      'FTF3100'     MsgIdArr(I)
     C                   ELSE
      *
      * Ensure record not locked
     C                   If        S1Sel = 'A' or S1Sel = 'D'
     C     S1SPRCOD      CHAIN     FTXTRHL1                           80
     C                   ENDIF
      *
      **  Do not allow more than one subfile selection at a time
     C                   IF        SelCount_A > 1
     C                   EVAL      *IN10 = *On
     C                   EVAL      S1SFRN = @RRNA
     C                   ADD       1             I
     C                   MOVE      'S1SEL'       FldNameArr(I)
     C                   MOVE      'FTF3101'     MsgIdArr(I)
     C                   ELSE
     C                   EVAL      S2Action   = S1SEL
     C                   EVAL      KeySprCode = S1SPRCOD
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Else selection is blank - turn off error indicator from prev record
     C                   ELSE
     C                   EVAL      *IN10 = *Off
     C                   ENDIF
      *
     C                   UPDATE    FT000322SA
     C                   READC     FT000322SA                             81
     C                   ENDDO
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * Init_B - Initialise Second Screen                                  *
      **********************************************************************
     C     Init_B        BEGSR
      *
      ** Load Screen 2 fields with info from file if not Insert
     C                   IF        S2Action = 'I'
     C                   EVAL      S2SPRDCD = *Blanks
     C                   EVAL      S2XRSDSC = *Blanks
     C                   EVAL      S2PNTDCD = *Blanks
     C                   ELSE
     C     KeySprCode    CHAIN     FTXTRHL0                           80
     C                   EVAL      S2SPRDCD = SPRCOD
     C                   EVAL      S2XRSDSC = XRSDSC
     C                   EVAL      S2PNTDCD = PNTDCD
     C                   ENDIF
      *
      ** Clear message subfile, screen fields and error flags
     C                   EXSR      ResetErrs_B
     C                   EVAL      *IN89 = *Off
     C                   EVAL      *IN91 = *Off
     C                   EVAL      Y = *Zero
     C                   CLEAR                   SubfileBRec
     C                   CLEAR                   FileCcyArr
      *
      ** Set screen conditioning indicators for this Action Code
     C                   SELECT
     C                   WHEN      S2Action = 'E'
     C                   EVAL      *IN70 = *On
     C                   EVAL      *IN72 = *Off
     C                   EVAL      *IN73 = *Off
     C                   Eval      *IN30 = *On
     C                   WHEN      S2Action = 'D'
     C                   EVAL      *IN70 = *On
     C                   EVAL      *IN72 = *Off
     C                   EVAL      *IN73 = *On
     C                   Eval      *IN30 = *On
     C                   WHEN      S2Action = 'I'
     C                   EVAL      *IN70 = *Off
     C                   EVAL      *IN72 = *Off
     C                   EVAL      *IN73 = *Off
     C                   EVAL      *IN74 = *Off
     C                   Eval      *IN30 = *Off
     C                   WHEN      S2Action = 'A'
     C                   EVAL      *IN70 = *Off
     C                   EVAL      *IN72 = *On
     C                   EVAL      *IN73 = *Off
     C                   Eval      *IN30 = *Off
     C                   ENDSL
      *
      **  Write the Second Screen footer & clear Subfile B (Second Screen)
     C                   WRITE     FT000322FB
     C                   EXSR      ClearSfl_B
      *
      **  If not Insert mode, position pointer
     C                   IF        S2Action <> 'I'
     C     S2SPRDCD      SETLL     FTXTRDL0
     C     S2SPRDCD      READE     FTXTRDL0                               99
     C                   ENDIF
      *
     C                   EXSR      LoadSfl_B
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * Screen_B - Display and process First screen
      ********************************************************************
     C     Screen_B      BEGSR
      *
      **  Write the message subfile
     C                   WRITE     FT000322M0
      *
      **  Display screen and wait for user response
     C                   EXFMT     FT000322CB
      *
     C                   SELECT
      *
      **  If F3, bypass further processing
     C                   WHEN      *INKC = *On
     C                   MOVEL     'X'           Control
      *
      **  If F10, check if this Code can be deleted
     C                   WHEN      *INKJ = *On
     C                   Eval      P@Code = S1SPRCOD
     C                   EXSR      CheckDelete
      *
      **  If F12, return to Screen 1
     C                   WHEN      *INKL = *On
     C                   EVAL      Control = 'A'
     C                   Unlock    FTXTRHL1
     C                   Unlock    FTXTRDL0
      *
      **  If ROLLUP (*IN87) - build next subfile page.  If there are any
      **  outstanding errors, do not allow rollup.
     C                   WHEN      *IN87 = *On
     C                   IF        I = *Zeros
     C                   EXSR      LoadSfl_B
     C                   ENDIF
      *
      **  Otherwise Enter has been pressed...
     C                   OTHER
     C                   EXSR      ResetErrs_B
      *
      **  ... validate screen fields if Insert or Amend modes
     C                   IF        S2Action = 'I'  OR  S2Action = 'A'
     C                   EXSR      Validate_B
     C                   ENDIF
      *
      **  ... send message 'Press F10 to confirm' if Delete mode
     C                   IF        S2Action = 'D'
     C                   ADD       1             I
     C                   MOVE      'Dummy'       FldNameArr(I)
     C                   MOVE      'FTF3121'     MsgIdArr(I)
     C                   ENDIF
      *
      ** If no errors, proceed with file update
     C                   IF        I = 0  AND  S2Action <> 'E'
     C                   EVAL      Control = 'U'
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Process error messages
     C                   EXSR      ProcErrs
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * LoadSfl_B - Load Subfile 'B' page
      ********************************************************************
     C     LoadSfl_B     BEGSR
      *
      **  Initialise work fields
     C                   Z-ADD     0             SflCount_B        3 0
      *
     C                   SELECT
      *
      **  a) Insert mode
      **       - Load the subfile with blank records
     C                   WHEN      S2Action = 'I'
     C                   DOW       SflCount_B < 5
     C                   ADD       1             @RRNB
     C                   ADD       1             SflCount_B
      *
      **  Write the (blank) record to the subfile
     C                   MOVE      *BLANK        S2SEL
     C                   Z-ADD     @RRNB         S2SFRN
     C                   CLEAR                   SubfileBRec
     C                   WRITE     FT000322SB
     C                   ENDDO
      *
      **  b) Enquire or Delete modes
      **       - Read all records from file to the subfile.
      **       - Do this until end of file or the subfile page is full.
     C                   WHEN      S2Action = 'E'  OR
     C                             S2Action = 'D'
      *
     C                   Eval      *In27 = *Off
      *
     C                   DOW       *IN99 = *Off  and  SflCount_B < 5
      *
      **  Increment the subfile record number and records written field
     C                   ADD       1             @RRNB
     C                   ADD       1             SflCount_B
      *
      ** Format PF/FTXTRDPD fields for screen
     C                   EXSR      FileToScreen
      *
      **  Write the record to the subfile
     C                   MOVE      *BLANK        S2SEL
     C                   Z-ADD     @RRNB         S2SFRN
     C                   WRITE     FT000322SB
      *
     C     S2SPRDCD      READE     FTXTRDL0                               99
     C                   ENDDO
      *
     C                   EVAL      *IN89 = *IN99
      *
      **  c) Amend mode
      **       - Read all records from file to the subfile.
      **       - Follow these with a set of blank records for more info.
      **       - Do this until the subfile page is full.
     C                   WHEN      S2Action = 'A'
      *
     C                   DOW       *IN99 = *Off  and  SflCount_B < 5
      *
      **  Increment the subfile record number, records written field and
      **  currency array
     C                   ADD       1             @RRNB
     C                   ADD       1             SflCount_B
     C                   EVAL      Y = Y + 1
     C                   EVAL      FileCcyArr(Y) = XRSCCY
     C                   EVAL      *IN71 = *On
     C                   EVAL      *IN74 = *On
     C                   EVAL      H@IN74 = '1'
      *
      ** Format PF/FTXTRDPD fields for screen
     C                   EXSR      FileToScreen
      *
      **  Write the record to the subfile
     C                   MOVE      *BLANK        S2SEL
     C                   Z-ADD     @RRNB         S2SFRN
     C                   WRITE     FT000322SB
      *
     C     S2SPRDCD      READE     FTXTRDL0                               99
     C                   ENDDO
      *
     C                   EVAL      *IN71 = *Off
     C                   EVAL      *IN74 = *Off
     C                   EVAL      H@IN74 = '0'
     C                   DOW       SflCount_B < 5
     C                   ADD       1             @RRNB
     C                   ADD       1             SflCount_B
      *
      **  Write the (blank) record to the subfile
     C                   MOVE      *BLANK        S2SEL
     C                   Z-ADD     @RRNB         S2SFRN
     C                   CLEAR                   SubfileBRec
     C                   WRITE     FT000322SB
     C                   ENDDO
      *
     C                   ENDSL
      *
      **  If no records exist set up an error message and deactivate SFLDSP.
      **  Also write the footer record format - this blanks existing subfile
      **  records.
     C                   IF        SflCount_B = 0
     C                   ADD       1             I
     C                   MOVE      'Dummy'       FldNameArr(I)
     C                   MOVE      'GEN0001'     MsgIdArr(I)
     C                   EVAL      *IN90 = *Off
     C                   WRITE     FT000322FB
     C                   EXSR      ProcErrs
     C                   ELSE
     C                   EVAL      *IN90 = *On
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Validate_B - Validate user entry to Second Screen
      ******************************************************************
     C     Validate_B    BEGSR
      *
      ** Validate Exchange Rate Spread Code
      *       - Mandatory in Insert mode (protected otherwise)
      *       - Must be unique on PF/FTXTRHPD
     C                   IF        S2Action = 'I'
      *
     C                   IF        S2SPRDCD = *Blanks
     C                   ADD       1             I
     C                   MOVE      'S2SPRDCD'    FldNameArr(I)
     C                   MOVE      'FTF3102'     MsgIdArr(I)
     C                   EVAL      *IN26 = *On
     C                   ELSE
     C     S2SPRDCD      CHAIN     FTXTRHL0                           80
      *
     C                   IF        *IN80 = *Off
     C                   ADD       1             I
     C                   MOVE      'S2SPRDCD'    FldNameArr(I)
     C                   MOVE      'FTF3103'     MsgIdArr(I)
     C                   EVAL      *IN26 = *On
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Exchange Rate Spread Description (mandatory field)
     C                   EVAL      *IN27 = *Off
     C                   IF        S2XRSDSC = *Blanks
     C                   ADD       1             I
     C                   MOVE      'S2XRSDSC'    FldNameArr(I)
     C                   MOVE      'FTF3104'     MsgIdArr(I)
     C                   EVAL      *IN27 = *On
     C                   ENDIF
      *
      ** Validate Parent Spread Code (optional)
      *       - If entered must not refer to itself
      *       - If '?' entered provide a list of possible Codes
      *       - If entered must refer to existing Ex. Rate Spread Code
      *       - If entered the Parent code must itself not have a Parent
     C                   IF        S2PNTDCD <> *Blanks
      *
     C                   IF        S2PNTDCD = S2SPRDCD
     C                   ADD       1             I
     C                   MOVE      'S2PNTDCD'    FldNameArr(I)
     C                   MOVE      'FTF3118'     MsgIdArr(I)
     C                   EVAL      *IN11 = *On
     C                   ENDIF
      *
     C                   IF        S2PNTDCD = '?'
      *
     C                   CALLB     'FT000950'
     C                   PARM      *Blanks       ParmSPRCOD
      *
     C                   MOVEL     ParmSPRCOD    S2PNTDCD
     C                   ENDIF
      *
     C     S2PNTDCD      CHAIN     FTXTRHL0                           80
      *
     C                   IF        *IN80 = *On
     C                   ADD       1             I
     C                   MOVE      'S2PNTDCD'    FldNameArr(I)
     C                   MOVE      'FTF3105'     MsgIdArr(I)
     C                   EVAL      *IN11 = *On
     C                   ELSE
      *
     C                   IF        PNTDCD <> *Blanks
     C                   ADD       1             I
     C                   MOVE      'S2PNTDCD'    FldNameArr(I)
     C                   MOVE      'FTF3106'     MsgIdArr(I)
     C                   EVAL      *IN11 = *On
     C                   ENDIF
      *
     C                   ENDIF
      *
 
      *  Ensure that the child itself is not a parent
     C     S1SPRCOD      Setll     FTXTRHL2                               80
     C                   If        *In80
     C                   ADD       1             I
     C                   MOVE      'S2PNTDCD'    FldNameArr(I)
     C                   MOVE      'FTF3210'     MsgIdArr(I)
     C                   EVAL      *IN11 = *On
     C                   Endif
 
     C                   ENDIF
      *
      ** Validate subfile fields
     C                   EXSR      ReadSfl_B
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      ********************************************************************
      * ReadSfl_B - Read and Validate Subfile 'B' record
      ********************************************************************
     C     ReadSfl_B     BEGSR
      *
      **  Read Subfile 'B'
     C                   READC     FT000322SB                             81
     C                   DOW       *IN81 = *Off
      *
     C                   IF        SubfileBRec <> *Blanks
     C                   EVAL      *IN91 = *On
     C                   MOVEA     '00000000'    *IN(12)
     C                   MOVEA     '00000000'    *IN(20)
     C                   EVAL      *IN71 = H@IN74
     C                   EVAL      *IN74 = H@IN74
     C                   EVAL      ZADIG    = SpreadDigits
     C                   EVAL      ZADEC    = SpreadDecs
      *
      **  Validate selection if entered (only possible in Amend mode)
     C                   IF        S2Action = 'A'  AND
     C                             S2SEL <> 'D'  AND  S2SEL <> *Blanks
     C                   EVAL      *IN12 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2SEL'       FldNameArr(I)
     C                   MOVE      'FTF3107'     MsgIdArr(I)
     C                   ENDIF
      *
      **  Validate Currency (mandatory field)
      **      - Check currency is valid on SDCURRPD & process '?'
     C                   IF        S2XRSCCY = *Blanks
     C                   EVAL      *IN13 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2XRSCCY'    FldNameArr(I)
     C                   MOVE      'FTF3108'     MsgIdArr(I)
      *
     C                   ELSE
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      S2XRSCCY      P@K101            3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        P@RTCD <> *Blanks
     C                   EVAL      *IN13 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2XRSCCY'    FldNameArr(I)
     C                   MOVE      'FTF3109'     MsgIdArr(I)
     C                   ELSE
      *
      **      - Make sure this currency is only entered once on subfile
      **        (only do this if it is a new entry i.e. *IN74 is off)
     C     A6CYCD        LOOKUP    SflCcyArr(1)                           82
     C                   IF        *IN82 = *Off  AND  *IN74 = *Off
     C     A6CYCD        LOOKUP    FileCcyArr(1)                          82
     C                   ENDIF
      *
     C                   IF        *IN82 = *On
     C                   EVAL      *IN13 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2XRSCCY'    FldNameArr(I)
     C                   MOVE      'FTF3126'     MsgIdArr(I)
     C                   ELSE
     C                   EVAL      Y = Y + 1
     C                   EVAL      SflCcyArr(Y) = A6CYCD
     C                   EVAL      S2XRSCCY    = A6CYCD
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of 'If P@RTCD <> *Blanks')
      *
      **  Cannot enter a Currency and no spread values
     C                   IF        S2MANBPC = *Blanks AND S2MANBSP = *Blanks AND
     C                             S2STPBPC = *Blanks AND S2STPBSP = *Blanks AND
     C                             S2MANSPC = *Blanks AND S2MANSSP = *Blanks AND
     C                             S2STPSPC = *Blanks AND S2STPSSP = *Blanks
     C                   EVAL      *IN14 = *On
     C                   EVAL      *IN15 = *On
     C                   EVAL      *IN17 = *On
     C                   EVAL      *IN18 = *On
     C                   EVAL      *IN20 = *On
     C                   EVAL      *IN21 = *On
     C                   EVAL      *IN23 = *On
     C                   EVAL      *IN24 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2XRSCCY'    FldNameArr(I)
     C                   MOVE      'FTF3127'     MsgIdArr(I)
     C                   ENDIF
      *
      ** Cannot enter base currency
      *
     C                   IF        S2XRSCCY = BJCYCD
     C                   EVAL      S2SFRN = @RRNB
     C                   EVAL      *In13 = *On
     C                   ADD       1             I
     C                   MOVE      'S2XRSCCY'    FldNameArr(I)
     C                   MOVE      'FTF3207'     MsgIdArr(I)
     C                   ENDIF
 
      *
      ** If base ccy is EURO or an in ccy, do not allow spread rates for 'IN' currencies.
      *
     C                   IF        S2XRSCCY = EuroCcy    AND
     C                             BJCYCD = EuroCcy
     C                   EVAL      S2SFRN = @RRNB
     C                   EVAL      *In13 = *On
     C                   ADD       1             I
     C                   MOVE      'S2XRSCCY'    FldNameArr(I)
     C                   MOVE      'FTF3208'     MsgIdArr(I)
     C                   ENDIF
 
     C                   IF        BaseCcyIn = 'Y' and
     C                             A6INCY = 'Y'
     C                   EVAL      *In13 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2XRSCCY'    FldNameArr(I)
     C                   MOVE      'FTF3209'     MsgIdArr(I)
     C                   ENDIF
 
      *
     C                   EVAL      P@K101 = *Blanks
     C                   ENDIF
      *                  (End of 'If S2XRSCCY = *Blanks')
      *
      *   Man Buy fields
      *   ~~~~~~~~~~~~~~
      ** Cannot enter Buy Spread Points and Buy Spread % simultaneously
     C                   IF        S2MANBPC <> *Blanks  AND
     C                             S2MANBSP <> *Blanks
     C                   EVAL      *IN14 = *On
     C                   EVAL      *IN15 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANBPC'    FldNameArr(I)
     C                   MOVE      'FTF3110'     MsgIdArr(I)
      *
     C                   ELSE
      *
      **  Validate Buy Spread Percentage (Manual)
      **      - Must be valid numeric format
      **      - Must be < 1
      **      - Cannot be zero
     C                   IF        S2MANBPC <> *Blanks
     C                   EVAL      ZFIELD   = *Blanks
     C                   EVAL      ZFIELD   = S2MANBPC
     C                   EVAL      ZALIGNok = 'Y'
      *
     C                   CALLB     'ZALIGN'      P@ZALIGN
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      *IN14 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANBPC'    FldNameArr(I)
     C                   MOVE      'FTF3112'     MsgIdArr(I)
     C                   ELSE
      *
     C                   MOVE      ZFIELD        WorkNumField
     C                   CALLB     'ZEDIT'       P@ZEDIT
     C                   MOVE      ZFIELD        S2MANBPC
      *
     C                   IF        WorkNumField >= 1  OR  WorkNumField = 0
     C                   EVAL      *IN14 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANBPC'    FldNameArr(I)
     C                   MOVE      'FTF3112'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of 'If ZALIGNok = 'N'')
      *
     C                   ENDIF
      *                  (End of 'If S2MANBPC <> *Blanks')
      *
      **  Validate Buy Spread Points (Manual)
      **      - Must be valid numeric format
      **      - Must be a positive amount
     C                   IF        S2MANBSP <> *Blanks
     C                   EVAL      ZFIELD   = *Blanks
     C                   EVAL      ZFIELD   = S2MANBSP
     C                   EVAL      ZALIGNok = 'Y'
      *
     C                   CALLB     'ZALIGN'      P@ZALIGN
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      *IN15 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANBSP'    FldNameArr(I)
     C                   MOVE      'FTF3113'     MsgIdArr(I)
     C                   ELSE
      *
     C                   MOVE      ZFIELD        WorkNumField
     C                   CALLB     'ZEDIT'       P@ZEDIT
     C                   MOVE      ZFIELD        S2MANBSP
      *
     C                   IF        WorkNumField <= 0
     C                   EVAL      *IN15 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANBSP'    FldNameArr(I)
     C                   MOVE      'FTF3113'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of 'If ZALIGNok = 'N'')
      *
     C                   ENDIF
      *                  (End of 'If S2MANBSP <> *Blanks')
      *
     C                   ENDIF
      *                  (End of 'If S2MANBPC and S2MANBSP <> *Blanks')
      *
      **  Validate Buy Spread Sign (Manual)
      **      - Prohibited if neither Spread % or Spread Points are entered
      **      - Mandatory if either Spread % or Spread Points are entered
      **      - Can only be '+' or '-'
     C                   IF        S2MANBPC = *Blanks AND S2MANBSP = *Blanks
      *
     C                   IF        S2MANBSN <> *Blanks
     C                   EVAL      *IN16 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANBSN'    FldNameArr(I)
     C                   MOVE      'FTF3119'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        S2MANBSN <> '+'  AND  S2MANBSN <> '-'
     C                   EVAL      *IN16 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANBSN'    FldNameArr(I)
     C                   MOVE      'FTF3116'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *
      *   STP Buy fields
      *   ~~~~~~~~~~~~~~
      ** Cannot enter Buy Spread Points and Buy Spread % simultaneously
     C                   IF        S2STPBPC <> *Blanks  AND
     C                             S2STPBSP <> *Blanks
     C                   EVAL      *IN20 = *On
     C                   EVAL      *IN21 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPBPC'    FldNameArr(I)
     C                   MOVE      'FTF3110'     MsgIdArr(I)
      *
     C                   ELSE
      *
      **  Validate Buy Spread Percentage (STP)
      **      - Must be valid numeric format
      **      - Must be < 1
     C                   IF        S2STPBPC <> *Blanks
     C                   EVAL      ZFIELD   = *Blanks
     C                   EVAL      ZFIELD   = S2STPBPC
     C                   EVAL      ZADIG    = SpreadDigits
     C                   EVAL      ZADEC    = SpreadDecs
     C                   EVAL      ZALIGNok = 'Y'
      *
     C                   CALLB     'ZALIGN'      P@ZALIGN
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      *IN20 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPBPC'    FldNameArr(I)
     C                   MOVE      'FTF3114'     MsgIdArr(I)
     C                   ELSE
      *
     C                   MOVE      ZFIELD        WorkNumField
     C                   CALLB     'ZEDIT'       P@ZEDIT
     C                   MOVE      ZFIELD        S2STPBPC
      *
     C                   IF        WorkNumField >= 1  OR  WorkNumField = 0
     C                   EVAL      *IN20 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPBPC'    FldNameArr(I)
     C                   MOVE      'FTF3114'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of 'If ZALIGNok = 'N'')
      *
     C                   ENDIF
      *                  (End of 'If S2STPBPC <> *Blanks')
      *
      **  Validate Buy Spread Points (STP)
      **      - Must be valid numeric format
      **      - Must be a positive amount
     C                   IF        S2STPBSP <> *Blanks
     C                   EVAL      ZFIELD   = *Blanks
     C                   EVAL      ZFIELD   = S2STPBSP
     C                   EVAL      ZALIGNok = 'Y'
      *
     C                   CALLB     'ZALIGN'      P@ZALIGN
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      *IN21 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPBSP'    FldNameArr(I)
     C                   MOVE      'FTF3115'     MsgIdArr(I)
     C                   ELSE
      *
     C                   MOVE      ZFIELD        WorkNumField
     C                   CALLB     'ZEDIT'       P@ZEDIT
     C                   MOVE      ZFIELD        S2STPBSP
      *
     C                   IF        WorkNumField <= 0
     C                   EVAL      *IN21 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPBSP'    FldNameArr(I)
     C                   MOVE      'FTF3115'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of 'If ZALIGNok = 'N'')
      *
     C                   ENDIF
      *                  (End of 'If S2STPBSP <> *Blanks')
      *
     C                   ENDIF
      *                  (End of 'If S2STPBPC and S2STPBSP <> *Blanks')
      *
      **  Validate Buy Spread Sign (STP)
      **      - Prohibited if neither Spread % or Spread Points are entered
      **      - Mandatory if either Spread % or Spread Points are entered
      **      - Can only be '+' or '-'
     C                   IF        S2STPBPC = *Blanks AND S2STPBSP = *Blanks
      *
     C                   IF        S2STPBSN <> *Blanks
     C                   EVAL      *IN22 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPBSN'    FldNameArr(I)
     C                   MOVE      'FTF3119'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        S2STPBSN <> '+'  AND  S2STPBSN <> '-'
     C                   EVAL      *IN22 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPBSN'    FldNameArr(I)
     C                   MOVE      'FTF3116'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      *   Man Sell fields
      *   ~~~~~~~~~~~~~~~
      ** Cannot enter Sell Spread Points and Sell Spread % simultaneously
     C                   IF        S2MANSPC <> *Blanks  AND
     C                             S2MANSSP <> *Blanks
     C                   EVAL      *IN17 = *On
     C                   EVAL      *IN18 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANSPC'    FldNameArr(I)
     C                   MOVE      'FTF3111'     MsgIdArr(I)
      *
     C                   ELSE
      *
      **  Validate Sell Spread Percentage (Manual)
      **      - Must be valid numeric format
      **      - Must be < 1
     C                   IF        S2MANSPC <> *Blanks
     C                   EVAL      ZFIELD   = *Blanks
     C                   EVAL      ZFIELD   = S2MANSPC
     C                   EVAL      ZADIG    = SpreadDigits
     C                   EVAL      ZADEC    = SpreadDecs
     C                   EVAL      ZALIGNok = 'Y'
      *
     C                   CALLB     'ZALIGN'      P@ZALIGN
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      *IN17 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANSPC'    FldNameArr(I)
     C                   MOVE      'FTF3124'     MsgIdArr(I)
     C                   ELSE
      *
     C                   MOVE      ZFIELD        WorkNumField
     C                   CALLB     'ZEDIT'       P@ZEDIT
     C                   MOVE      ZFIELD        S2MANSPC
      *
     C                   IF        WorkNumField >= 1  OR  WorkNumField = 0
     C                   EVAL      *IN17 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANSPC'    FldNameArr(I)
     C                   MOVE      'FTF3124'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of 'If ZALIGNok = 'N'')
      *
     C                   ENDIF
      *                  (End of 'If S2MANSPC <> *Blanks')
      *
      **  Validate Sell Spread Points (Manual)
      **      - Must be valid numeric format
      **      - Must be a positive amount
     C                   IF        S2MANSSP <> *Blanks
     C                   EVAL      ZFIELD   = *Blanks
     C                   EVAL      ZFIELD   = S2MANSSP
     C                   EVAL      ZALIGNok = 'Y'
      *
     C                   CALLB     'ZALIGN'      P@ZALIGN
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      *IN18 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANSSP'    FldNameArr(I)
     C                   MOVE      'FTF3125'     MsgIdArr(I)
     C                   ELSE
      *
     C                   MOVE      ZFIELD        WorkNumField
     C                   CALLB     'ZEDIT'       P@ZEDIT
     C                   MOVE      ZFIELD        S2MANSSP
      *
     C                   IF        WorkNumField <= 0
     C                   EVAL      *IN18 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANSSP'    FldNameArr(I)
     C                   MOVE      'FTF3125'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of 'If ZALIGNok = 'N'')
      *
     C                   ENDIF
      *                  (End of 'If S2MANSSP <> *Blanks')
      *
     C                   ENDIF
      *                  (End of 'If S2MANSPC and S2MANSSP <> *Blanks')
      *
      **  Validate Sell Spread Sign (Manual)
      **      - Prohibited if neither Spread % or Spread Points are entered
      **      - Mandatory if either Spread % or Spread Points are entered
      **      - Can only be '+' or '-'
     C                   IF        S2MANSPC = *Blanks AND S2MANSSP = *Blanks
      *
     C                   IF        S2MANSSN <> *Blanks
     C                   EVAL      *IN19 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANSSN'    FldNameArr(I)
     C                   MOVE      'FTF3119'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        S2MANSSN <> '+'  AND  S2MANSSN <> '-'
     C                   EVAL      *IN19 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2MANSSN'    FldNameArr(I)
     C                   MOVE      'FTF3116'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *
      *   STP Sell fields
      *   ~~~~~~~~~~~~~~~
      ** Cannot enter Sell Spread Points and Sell Spread % simultaneously
     C                   IF        S2STPSPC <> *Blanks  AND
     C                             S2STPSSP <> *Blanks
     C                   EVAL      *IN23 = *On
     C                   EVAL      *IN24 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPSPC'    FldNameArr(I)
     C                   MOVE      'FTF3111'     MsgIdArr(I)
      *
     C                   ELSE
      *
      **  Validate Sell Spread Percentage (STP)
      **      - Must be valid numeric format
      **      - Must be < 1
     C                   IF        S2STPSPC <> *Blanks
     C                   EVAL      ZFIELD   = *Blanks
     C                   EVAL      ZFIELD   = S2STPSPC
     C                   EVAL      ZADIG    = SpreadDigits
     C                   EVAL      ZADEC    = SpreadDecs
     C                   EVAL      ZALIGNok = 'Y'
      *
     C                   CALLB     'ZALIGN'      P@ZALIGN
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      *IN23 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPSPC'    FldNameArr(I)
     C                   MOVE      'FTF3122'     MsgIdArr(I)
     C                   ELSE
      *
     C                   MOVE      ZFIELD        WorkNumField
     C                   CALLB     'ZEDIT'       P@ZEDIT
     C                   MOVE      ZFIELD        S2STPSPC
      *
     C                   IF        WorkNumField >= 1  OR  WorkNumField = 0
     C                   EVAL      *IN23 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPSPC'    FldNameArr(I)
     C                   MOVE      'FTF3122'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of 'If ZALIGNok = 'N'')
      *
     C                   ENDIF
      *                  (End of 'If S2STPSPC <> *Blanks')
      *
      **  Validate Sell Spread Points (STP)
      **      - Must be valid numeric format
      **      - Must be a positive amount
     C                   IF        S2STPSSP <> *Blanks
     C                   EVAL      ZFIELD   = *Blanks
     C                   EVAL      ZFIELD   = S2STPSSP
     C                   EVAL      ZALIGNok = 'Y'
      *
     C                   CALLB     'ZALIGN'      P@ZALIGN
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      *IN24 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPSSP'    FldNameArr(I)
     C                   MOVE      'FTF3123'     MsgIdArr(I)
     C                   ELSE
      *
     C                   MOVE      ZFIELD        WorkNumField
     C                   CALLB     'ZEDIT'       P@ZEDIT
     C                   MOVE      ZFIELD        S2STPSSP
      *
     C                   IF        WorkNumField <= 0
     C                   EVAL      *IN24 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPSSP'    FldNameArr(I)
     C                   MOVE      'FTF3123'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of 'If ZALIGNok = 'N'')
      *
     C                   ENDIF
      *                  (End of 'If S2STPSSP <> *Blanks')
      *
     C                   ENDIF
      *                  (End of 'If S2STPSPC and S2STPSSP <> *Blanks')
      *
      **  Validate Sell Spread Sign (STP)
      **      - Prohibited if neither Spread % or Spread Points are entered
      **      - Mandatory if either Spread % or Spread Points are entered
      **      - Can only be '+' or '-'
     C                   IF        S2STPSPC = *Blanks AND S2STPSSP = *Blanks
      *
     C                   IF        S2STPSSN <> *Blanks
     C                   EVAL      *IN25 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPSSN'    FldNameArr(I)
     C                   MOVE      'FTF3119'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        S2STPSSN <> '+'  AND  S2STPSSN <> '-'
     C                   EVAL      *IN25 = *On
     C                   EVAL      S2SFRN = @RRNB
     C                   ADD       1             I
     C                   MOVE      'S2STPBSN'    FldNameArr(I)
     C                   MOVE      'FTF3116'     MsgIdArr(I)
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      ** Else record is blank - turn off error indicators from prev record
     C                   ELSE
     C                   MOVEA     '0000000000'  *IN(12)
     C                   MOVEA     '000'         *IN(22)
     C                   ENDIF
      *                  (End of 'If SubfileBRec <> *Blanks')
      *
     C                   UPDATE    FT000322SB
     C                   READC     FT000322SB                             81
     C                   ENDDO
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      * FmtParentFlds - Format PF/FTXTRHPD fields for screen
      ******************************************************************
     C     FmtParentFlds BEGSR
      *
     C                   EVAL      S1SPRCOD = SPRCOD
     C                   EVAL      S1XRSDSC = XRSDSC
     C                   EVAL      S1PNTDCD = PNTDCD
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * FileToScreen - Format PF/FTXTRDPD fields for screen
      ******************************************************************
     C     FileToScreen  BEGSR
      *
      ** Clear the previous record
     C                   CLEAR                   SubfileBRec
      *
      ** Load Currency to screen
     C                   EVAL      S2XRSCCY = XRSCCY
      *
      ** Format Manual Buy Spread %
     C                   EVAL      ZADEC = SpreadDecs
      *
     C                   IF        MANBPC <> *Zeros
     C                   MOVE (P)  MANBPC        ZFIELD                         ************
     C                   CALLB     'ZEDIT'       P@ZEDIT
      *
     C                   MOVE      ZFIELD        S2MANBPC
     C                   MOVE      *Blanks       ZFIELD
     C                   ENDIF
      *
      ** Format Manual Buy Spread Points
     C                   IF        MANBSP <> *Zeros
     C                   MOVE (P)  MANBSP        ZFIELD                         ************
      *
     C                   CALLB     'ZEDIT'       P@ZEDIT
      *
     C                   MOVE      ZFIELD        S2MANBSP
     C                   MOVE      *Blanks       ZFIELD
     C                   ENDIF
      *
      ** Format Manual Sell Spread %
     C                   IF        MANSPC <> *Zeros
     C                   MOVE (P)  MANSPC        ZFIELD                         ************
      *
     C                   CALLB     'ZEDIT'       P@ZEDIT
      *
     C                   MOVE      ZFIELD        S2MANSPC
     C                   MOVE      *Blanks       ZFIELD
     C                   ENDIF
      *
      ** Format Manual Sell Spread Points
     C                   IF        MANSSP <> *Zeros
     C                   MOVE (P)  MANSSP        ZFIELD                         ************
      *
     C                   CALLB     'ZEDIT'       P@ZEDIT
      *
     C                   MOVE      ZFIELD        S2MANSSP
     C                   MOVE      *Blanks       ZFIELD
     C                   ENDIF
      *
      ** Format STP Buy Spread %
     C                   IF        STPBPC <> *Zeros
     C                   MOVE (P)  STPBPC        ZFIELD                         ************
      *
     C                   CALLB     'ZEDIT'       P@ZEDIT
      *
     C                   MOVE      ZFIELD        S2STPBPC
     C                   MOVE      *Blanks       ZFIELD
     C                   ENDIF
      *
      ** Format STP Buy Spread Points
     C                   IF        STPBSP <> *Zeros
     C                   MOVE (P)  STPBSP        ZFIELD                         ************
      *
     C                   CALLB     'ZEDIT'       P@ZEDIT
      *
     C                   MOVE      ZFIELD        S2STPBSP
     C                   MOVE      *Blanks       ZFIELD
     C                   ENDIF
      *
      ** Format STP Sell Spread %
     C                   IF        STPSPC <> *Zeros
     C                   MOVE (P)  STPSPC        ZFIELD                         ************
      *
     C                   CALLB     'ZEDIT'       P@ZEDIT
      *
     C                   MOVE      ZFIELD        S2STPSPC
     C                   MOVE      *Blanks       ZFIELD
     C                   ENDIF
      *
      ** Format STP Sell Spread Points
     C                   IF        STPSSP <> *Zeros
     C                   MOVE (P)  STPSSP        ZFIELD                         ************
      *
     C                   CALLB     'ZEDIT'       P@ZEDIT
      *
     C                   MOVE      ZFIELD        S2STPSSP
     C                   MOVE      *Blanks       ZFIELD
     C                   ENDIF
      *
      ** Load 'Sign' fields to screen
     C                   EVAL      S2MANBSN = MANBSN
     C                   EVAL      S2STPBSN = STPBSN
     C                   EVAL      S2MANSSN = MANSSN
     C                   EVAL      S2STPSSN = STPSSN
      *
     C                   ENDSR
     C**********************************************************************
      /EJECT
      **********************************************************************
      * ScreenToFile - ZALIGN screen fields that are numeric on file
      **********************************************************************
     C     ScreenToFile  BEGSR
      *
     C                   EVAL      ZADIG    = SpreadDigits
     C                   EVAL      ZADEC    = SpreadDecs
     C                   EVAL      ZALIGNok = 'Y'
      *
     C                   CALLB     'ZALIGN'      P@ZALIGN
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = ZFIELD
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
      * ResetErrs_A - Reset all error indicators and flags
      **********************************************************************
     C     ResetErrs_A   BEGSR
      *
     C                   Z-ADD     *Zero         I
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
      *
     C                   EVAL      SelCount_A = 0
     C                   EVAL      S2Action   = *Blanks
     C                   EVAL      *IN98 = *Off
     C                   EVAL      *IN10 = *Off
      *
      * Clear message subfile
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      **********************************************************************
      * ResetErrs_B - Reset all error indicators and flags on Second Screen
      **********************************************************************
     C     ResetErrs_B   BEGSR
      *
     C                   Z-ADD     *Zero         I
     C                   Z-ADD     *Zero         Y
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   SflCcyArr
      *
     C                   MOVEA     '0000000000'  *IN(11)
     C                   MOVEA     '000000'      *IN(21)
     C                   EVAL      *IN87 = *Off
      *
      * Clear message subfile
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * ProcErrs - Process errors (both screens)
      *****************************************************************
     C     ProcErrs      BEGSR
      *
      * Clear message subfile
     C                   CALL      'ZA0250'
      *
      ** Set up the action code to be used by the message handler
     C                   EVAL      ActionCode = 'I'
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
      *
     C                   ENDSR
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      * ClearSfl_A - Clear Subfile A (first screen)
      *****************************************************************
     C     ClearSfl_A    BEGSR
      *
      **  Initialise subfile relative record number.
     C                   Z-ADD     0             @RRNA             5 0
      *
      **  Clear subfile by writing control record with SFLCLR active.
     C                   EVAL      *IN97 = *On
     C                   WRITE     FT000322CA
     C                   EVAL      *IN97 = *Off
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ClearSfl_B - Clear Subfile A (first screen)
      *****************************************************************
     C     ClearSfl_B    BEGSR
      *
      **  Initialise subfile relative record number.
     C                   Z-ADD     0             @RRNB             5 0
      *
      **  Clear subfile by writing control record with SFLCLR active.
     C                   EVAL      *IN88 = *On
     C                   WRITE     FT000322CB
     C                   EVAL      *IN88 = *Off
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ProcInsert - Write new records to Parent and Child files
      ******************************************************************
     C     ProcInsert    BEGSR
      *
      ** Write new record to Parent file (FTXTRHPD)
     C                   EVAL      SPRCOD = S2SPRDCD
     C                   EVAL      XRSDSC = S2XRSDSC
     C                   EVAL      PNTDCD = S2PNTDCD
      *
     C                   WRITE     FTXTRHD0
      *
      ** READC subfile for all non-blank records
     C                   READC     FT000322SB                             81
      *
     C                   DOW       *IN81 = *Off
      *
     C                   IF        SubfileBRec <> *Blanks
     C                   EVAL      SPRDCD = S2SPRDCD
     C                   EVAL      XRSCCY = S2XRSCCY
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2MANBPC
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        MANBPC
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2MANBSP
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        MANBSP
      *
     C                   EVAL      MANBSN = S2MANBSN
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2MANSPC
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        MANSPC
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2MANSSP
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        MANSSP
      *
     C                   EVAL      MANSSN = S2MANSSN
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2STPBPC
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        STPBPC
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2STPBSP
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        STPBSP
      *
     C                   EVAL      STPBSN = S2STPBSN
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2STPSPC
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        STPSPC
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2STPSSP
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        STPSSP
      *
     C                   EVAL      STPSSN = S2STPSSN
      *
      ** Write new record to Child file (FTXTRDPD)
     C                   WRITE     FTXTRDD0
     C                   ENDIF
      *                  (End of 'If SubfileBRec <> *Blanks')
      *
     C                   READC     FT000322SB                             81
     C                   ENDDO
      *
      ** Set action to 'Amend' so that user sees what (s)he has just entered
     C                   EVAL      S2Action = 'A'
     C                   EVAL      KeySprCode = S2SPRDCD
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      **********************************************************************
      * ProcAmend - Update Parent and Child files during Amend
      **********************************************************************
     C     ProcAmend     BEGSR
      *
      ** Update record on Parent file (FTXTRHPD)
     C     S2SPRDCD      CHAIN     FTXTRHL1                           80
      *
     C                   IF        *IN80 = *On
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBFILE = 'FTXTRHL1'
     C                   EVAL      DBKEY  = S2SPRDCD
     C                   EXSR      *PSSR
     C                   ELSE
      *
     C                   EVAL      SPRCOD = S2SPRDCD
     C                   EVAL      XRSDSC = S2XRSDSC
     C                   EVAL      PNTDCD = S2PNTDCD
      *
     C                   UPDATE    FTXTRHD0
     C     *Loval        Setll     FTXTRHD0
     C                   Unlock    FTXTRHL1
     C                   Commit
      *
     C                   ENDIF
      *
      ** READC subfile for all non-blank records.  When a record is found,
      ** read Child file to update the corresponding record.
     C                   READC     FT000322SB                             81
      *
     C                   DOW       *IN81 = *Off
      *
     C                   IF        SubfileBRec <> *Blanks
     C     KeyChildL0    CHAIN     FTXTRDL0                           99
      *
      ** Delete this record if it has been flagged with 'D'
     C                   IF        S2SEL = 'D'
      *
     C                   IF        *IN99 = *On
     C                   EVAL      DBASE  = 4
     C                   EVAL      DBFILE = 'FTXTRDPD'
     C                   EVAL      DBKEY  = S2SPRDCD + S2XRSCCY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   DELETE    FTXTRDD0
      *
      ** Else record not flagged, must be a new or amended record
     C                   ELSE
      *
     C                   EVAL      SPRDCD = S2SPRDCD
     C                   EVAL      XRSCCY = S2XRSCCY
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2MANBPC
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        MANBPC
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2MANBSP
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        MANBSP
      *
     C                   EVAL      MANBSN = S2MANBSN
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2MANSPC
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        MANSPC
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2MANSSP
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        MANSSP
      *
     C                   EVAL      MANSSN = S2MANSSN
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2STPBPC
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        STPBPC
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2STPBSP
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        STPBSP
      *
     C                   EVAL      STPBSN = S2STPBSN
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2STPSPC
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        STPSPC
      *
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZFIELD = S2STPSSP
     C                   EXSR      ScreenToFile
     C                   MOVE (P)  ZFIELD        STPSSP
      *
     C                   EVAL      STPSSN = S2STPSSN
      *
      ** If record not on LF/FTXTRDL0, this is an addition to the subfile
      ** - write a new record to file.  Otherwise the subfile record is
      ** already on the file - update as usual.
     C                   IF        *IN99 = *On
     C                   WRITE     FTXTRDD0
     C                   ELSE
     C                   UPDATE    FTXTRDD0
     C                   ENDIF
      *
     C                   ENDIF
      *                  (End of 'If S2SEL = 'D'')
      *
     C                   ENDIF
      *                  (End of 'If SubfileBRec <> *Blanks')
      *
     C                   READC     FT000322SB                             81
     C                   ENDDO
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * ProcDelete - Delete records from Parent and Child files
      ******************************************************************
     C     ProcDelete    BEGSR
      *
      **  Delete Parent record
     C     S2SPRDCD      CHAIN     FTXTRHL1                           80
      *
     C                   IF        *IN80 = *On
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBFILE = 'FTXTRHL1'
     C                   EVAL      DBKEY  = S2SPRDCD
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C                   DELETE    FTXTRHD0
     C                   ENDIF
      *
      **  Delete all Child records with this Exchange Rate Spread Code
     C     S2SPRDCD      SETLL     FTXTRDL0
     C     S2SPRDCD      READE     FTXTRDL0                               99
      *
     C                   DOW       *IN99 = *Off
     C                   DELETE    FTXTRDD0
     C     S2SPRDCD      READE     FTXTRDL0                               99
     C                   ENDDO
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      **********************************************************************
      * CheckDelete - Check if the Exchange Rate Spread Code is used in
      *               the following tables:
      *                   - Default payment charge definition
      *                   - Incoming payments
      *                   - Outgoing payments
      *                   - Request for Transfers
      *                   - Customer Credit Transfers
      **********************************************************************
     C     CheckDelete   BEGSR
      *
     C                   CALLB     'FTC0005'
     C                   PARM                    P@Code            5
     C                   PARM      '*ALL '       P@Code_Type       5
     C                   PARM                    P@Del_In          1
     C                   PARM                    P@Del_Ot          1
     C                   PARM                    P@Del_CP          1
     C                   PARM                    P@Del_CC          1
     C                   PARM                    P@Del_RF          1
     C                   PARM                    P@Del_CT          1
     C                   PARM                    P@Del_PC          1
     C                   PARM                    P@Error           1
      *
     C                   If        P@Error = 'Y'
     C                   Eval      DBASE = 6
     C                   Eval      DBKEY = P@Code + P@Code_Type
     C                   Exsr      *PSSR
     C                   Endif
      *
      **  If Code used by Incoming Payments table send message and
      **  prevent delete.
     C                   If        P@Del_IN  =  'Y'   Or
     C                             P@Del_OT  =  'Y'   Or
     C                             P@Del_CP  =  'Y'   Or
     C                             P@Del_CC  =  'Y'   Or
     C                             P@Del_RF  =  'Y'   Or
     C                             P@Del_CT  =  'Y'   Or
     C                             P@Del_PC  =  'Y'
     C                   ADD       1             I
     C                   MOVE      'Dummy'       FldNameArr(I)
     C                   MOVE      'FTF3012'     MsgIdArr(I)
     C                   EVAL      Control = 'A'
     C                   ELSE
     C                   Eval      *INKL = *On
     C                   Eval      S2Action = 'D'
     C                   EVAL      Control = 'U'
     C                   ENDIF
 
      ** Check to see if the record to be deleted is a parent spread. If
      ** it is do not allow the set to be deleted, and send a message to
      ** the user.
 
     C     P@CODE        Chain     ParentO                            80
 
     C                   If        not *IN80
 
     C                   Add       1             I
     C                   Eval      FldNameArr(I) = 'Dummy'
     C                   Eval      MsgIdArr(I) = 'FTF3016'
     C                   Eval      MsgDtaArr(I) = SPRCOD
     C                   Eval      Control = 'B'
     C                   Eval      *INKL = *Off
 
     C                   EndIf
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * XtSr - Record Locking                                         *
      *                                                               *
      * Called by: *Error                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     XtSr          Begsr
     C                   Eval      XtLocked = 'N'
     C                   If        XtStatus = Record_Locked
     C                   Eval      XtLocked = 'Y'
     C                   Eval      I = I + 1
     C                   MOVE      'FTF3151'     MsgIdArr(I)
     C                   MOVE      'S1SEL'       FldNameArr(I)
     C                   Exsr      ProcErrs
     C                   Eval      S1SFRN = @RRNA
     C     S1SFRN        CHAIN     FT000322SA                         80
     C                   Eval      *IN10 = *ON
     C                   UPDATE    FT000322SA
     C                   Eval      ReturnPt = '*DETC '
     C                   Endif
     C                   Endsr     ReturnPt
      /EJECT
      *****************************************************************
      *                                                               *
      * YtSr - Record Locking                                         *
      *                                                               *
      * Called by: *Error                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     YtSr          Begsr
     C                   Eval      YtLocked = 'N'
     C                   If        YtStatus = Record_Locked
     C                   Eval      YtLocked = 'Y'
     C                   Eval      I = 1
     C                   MOVE      'FTF3151'     MsgIdArr(I)
     C                   MOVE      'DUMMY'       FldNameArr(I)
     C                   Eval      S2SFRN = @RRNB
     C     S2SFRN        CHAIN     FT000322SB                         80
     C                   EVAL      S2SEL = *Blanks
     C                   UPDATE    FT000322SB
     C                   Eval      ReturnPt = '*DETC '
     C                   Endif
     C                   Endsr     ReturnPt
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
     C                   MOVEL     'FT000322S1'  DBPGM
      *
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     SWID
     C                   MOVEL     PsUser        SUSER
      *
      ** Parameter list for ZALIGN
     C     P@ZALIGN      PLIST
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
      ** Parameter list for ZEDIT
     C     P@ZEDIT       PLIST
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
      *
      ** Key list for access to LF/FTXTRPL0
     C     KeyChildL0    KLIST
     C                   KFLD                    S2SPRDCD
     C                   KFLD                    S2XRSCCY
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 005*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Access currency details for base currency
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      BJCYCD        P@K101            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
      * Save whether the base currency is an 'IN' currency
     C                   EVAL      BaseCcyIN = A6INCY
 
      *
      ** Access General Legder Details
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
 
      *
      ** Save euro currency
      *
     C                   EVAL      EuroCcy = BKEURO
 
      *
      * Message subfile control
     C                   MOVE      '1'           *IN93
     C                   MOVEL     '*'           S1PGMQ
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY FTCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
