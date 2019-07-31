     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Default Charge Code Overrides maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management module                            *
      *                                                               *
      *  ME1570 - Default Charge Code Overrides Maintenance           *
      *                                                               *
      *  Function:  This module displays and maintain Default Charge  *
      *             Code Overrides                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CFT009  *CREATE    Date 05Jun00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         Function key 3                                  *
      *    05         Function key 5                                  *
      *    12         Function key 12                                 *
      *    30         Enquire mode, protect screen fields             *
      *    31-50      Screen fields error indicators                  *
      *    80         Chain on MEGNCRL0                               *
      *    81         Setll on FTPDOCL0                               *
      *    82         Setll on FTXTRHL0                               *
      *    83         Setll on FTPCHGL0                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * VALIDATE    - Validate screen fields                          *
      * CHKCHGCDE   - Checking for invalid charge codes               *
      * FILE2SCREEN - Moving file fields to screen fields             *
      * SCREEN2FILE - Moving screen fields to file fields             *
      * SNDMSG      - Send Program Message                            *
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialise                                      *
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
 
     FME1570DF  CF   E             WORKSTN
     FFTPCHGL0  IF   E           K DISK
     FFTXTRHL0  IF   E           K DISK
     FFTPDOCL0  IF   E           K DISK
     FMEGNCRL0  UF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D Stars           C                   '*****'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SGncr           DS           268
      *
      * Stored master file format fields
      *
     D FGncr         E DS                  EXTNAME(MEGNCRPD)
      *
      * Current/previous master file format fields for change control
      *
     DMsgDs            DS
     D  MsgId                  1      7
     D  MsgF                   8     17    INZ('MEMSG')
     D  MsgLib                18     27    INZ('*LIBL')
     D  MsgDta                28    283    INZ(*Blank)
     D  MsgRel               284    288    INZ('*SAME')
     D  FtMsgq               289    298    INZ(*Blank)
     D  FtMsgt               299    305    INZ(*Blank)
      *
      ** Parameters for AOCREPT
      *
     D MsgArray        S             32    DIM(20) CTDATA
      *
      ** Messages array
      *
     D IndArray        S              1    DIM(18) INZ('0')
      *
      ** Error Indicators array
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D ActionCode      S              1
     D MsgType         S              3
     D MsgSet          S              3
     D KeyPress        S              3
      *
      ** *Entry parameters
      *
     D KMsgType        S              3
     D KMsgSet         S              3  0
      *
      ** Key fields for MEGNCRL0
      *
     D Error           S              1    INZ('Y')
      *
      **  Screen in error indicator
      *
     D ErrorFld        S              1    INZ('N')
      *
      **  Field in error indicator
      *
     D Idx             S              2  0
      *
      ** Counter for messages array
      *
     D Ind             S              2  0
      *
      ** Counter for error indicators array
      *
     D ChrgKey         S              5
      *
      ** Key for FTPCHGL0
      *
     D Code            S              5
      *
      ** Entry parameter for FT000940, FT000950, FT000960
      *
      *****************************************************************
 
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
 
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C                   Eval      SRUNA = AGMRDT
 
      ** Retrieve details
 
     C     KTypeSet      Chain     MEGNCRL0                           80
      *
     C                   If        *In80 = *On
 
      ** If not found, database error in file MEGNCRL0
 
     C     *LOCK         IN        LDA
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      DBFILE =  'MEGNCRL0'
     C                   Eval      DBKEY  =  'KTypeSet'
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBASE  =  001
     C                   Eval      DBMOD  =  PSProcMod
     C                   Eval      DBPROC =  'MAIN'
     C                   OUT       LDA
     C                   Exsr      *PSSR
      *
     C                   Endif
 
      ** Move file fields into screen fields
 
     C                   Exsr      File2Screen
      *
     C                   Dow       Error = 'Y'
 
      ** Write error messages
 
     C                   Write     #MSGCTL
 
      ** Show screen
 
     C                   Exfmt     ME1570F1
 
      ** Clear error messages
 
     C                   Call      'ZA0250'
 
      ** Reset error indicators
 
     C                   MoveA     '000000000000'*In(31)
     C                   MoveA     '00000000'    *In(43)
      *
     C                   Select
 
      ** F3 - Exit
 
     C                   When      *In03 = *ON
     C                   Eval      KeyPress = 'F03'
     C                   Eval      Error = 'N'
 
      ** F12 - Previous
 
     C                   When      *In12 = *On
     C                   Eval      KeyPress = 'F12'
     C                   Eval      Error = 'N'
 
      ** F5 - Refresh
 
     C                   When      *In05 = *On
     C                   Exsr      File2Screen
      *
     C                   Other
 
      ** Validate screen
 
     C                   If        ActionCode <> 'E'
     C                   Exsr      Validate
     C                   Endif
      *
     C                   Endsl
      *
     C                   Enddo
      *
     C                   If        *In03 = *Off and *In12 = *Off
 
      ** Move screen fields into file fields
 
     C                   Exsr      Screen2File
 
      ** Update MEGNCRL0
 
     C                   Update    @GNCRPD
      *
     C                   Endif
 
      ** Update saved record image
 
     C                   Eval      SGncr = FGncr
      *
     C                   Seton                                        LR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATE - Validate screen fields                             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Validate      Begsr
 
      ** Initialise error indicators array and counters
 
     C                   Reset                   IndArray
     C                   Eval      Idx = 1
     C                   Eval      Ind = 0
     C                   Eval      ErrorFld = 'N'
 
      ** ? processing
 
     C     '?'           Scan      SPDOCD                                 96
 
     C                   If        *In96
 
     C                   Call      'FT000960'
     C                   Parm      *Blanks       Code
 
     C                   Eval      SPDOCD = Code
     C                   Eval      ErrorFld = 'Y'
 
     C                   Else
 
      ** Payment dates offset code table
 
     C     SPDOCD        Setll     FTPDOCL0                               81
      *
     C                   If        *In81 = *Off AND SPDOCD <> Stars
     C                             AND SPDOCD <> *Blanks
     C                   Eval      ErrorFld = 'Y'
     C                   Eval      *In31 = *On
     C                   Eval      MsgDta = MsgArray(Idx)
     C                   Eval      MsgId = 'MIN0417'
     C                   Exsr      SndMsg
     C                   Endif
      *
     C                   Endif
      *
     C                   Add       1             Idx
 
      ** ? processing
 
     C     '?'           Scan      SFXSCD                                 96
     C                   If        *In96
 
     C                   Call      'FT000950'
     C                   Parm      *Blanks       Code
 
     C                   Eval      SFXSCD = Code
     C                   Eval      ErrorFld = 'Y'
 
     C                   Else
 
      ** Exchange rate spread parent
 
     C     SFXSCD        Setll     FTXTRHL0                               82
      *
     C                   If        *In82 = *Off AND SFXSCD <> Stars
     C                             AND SFXSCD <> *Blanks
     C                   Eval      ErrorFld = 'Y'
     C                   Eval      *In32 = *On
     C                   Eval      MsgDta = MsgArray(Idx)
     C                   Eval      MsgId = 'MIN0417'
     C                   Exsr      SndMsg
     C                   Endif
      *
     C                   Endif
      *
     C                   Eval      ChrgKey = SSWSCD
     C                   Exsr      ChkChgCde
     C                   Eval      SSWSCD = Chrgkey
      *
     C                   Eval      ChrgKey = SADVCD
     C                   Exsr      ChkChgCde
     C                   Eval      SADVCD = Chrgkey
      *
     C                   Eval      ChrgKey = SSWPCD
     C                   Exsr      ChkChgCde
     C                   Eval      SSWPCD = Chrgkey
      *
     C                   Eval      ChrgKey = SCABCD
     C                   Exsr      ChkChgCde
     C                   Eval      SCABCD = Chrgkey
      *
     C                   Eval      ChrgKey = STLXCD
     C                   Exsr      ChkChgCde
     C                   Eval      STLXCD = Chrgkey
      *
     C                   Eval      ChrgKey = SCHQCD
     C                   Exsr      ChkChgCde
     C                   Eval      SCHQCD = Chrgkey
      *
     C                   Eval      ChrgKey = STPHCD
     C                   Exsr      ChkChgCde
     C                   Eval      STPHCD = Chrgkey
      *
     C                   Eval      ChrgKey = SMI0CD
     C                   Exsr      ChkChgCde
     C                   Eval      SMI0CD = Chrgkey
      *
     C                   Eval      ChrgKey = SCOLCD
     C                   Exsr      ChkChgCde
     C                   Eval      SCOLCD = Chrgkey
      *
     C                   Eval      ChrgKey = SMI1CD
     C                   Exsr      ChkChgCde
     C                   Eval      SMI1CD = Chrgkey
      *
     C                   Eval      ChrgKey = SCORCD
     C                   Exsr      ChkChgCde
     C                   Eval      SCORCD = Chrgkey
      *
     C                   Eval      ChrgKey = SMI2CD
     C                   Exsr      ChkChgCde
     C                   Eval      SMI2CD = Chrgkey
      *
     C                   Eval      ChrgKey = SDEDCD
     C                   Exsr      ChkChgCde
     C                   Eval      SDEDCD = Chrgkey
      *
     C                   Eval      ChrgKey = SMI3CD
     C                   Exsr      ChkChgCde
     C                   Eval      SMI3CD = Chrgkey
      *
     C                   Eval      ChrgKey = SFCCCD
     C                   Exsr      ChkChgCde
     C                   Eval      SFCCCD = Chrgkey
      *
     C                   Eval      ChrgKey = SMI4CD
     C                   Exsr      ChkChgCde
     C                   Eval      SMI4CD = Chrgkey
      *
     C                   Eval      ChrgKey = STCOCD
     C                   Exsr      ChkChgCde
     C                   Eval      STCOCD = Chrgkey
      *
     C                   Eval      ChrgKey = SMI5CD
     C                   Exsr      ChkChgCde
     C                   Eval      SMI5CD = Chrgkey
 
      ** Error indicators
 
     C                   MoveA     IndArray      *In(33)
      *
     C                   If        ErrorFld = 'N'
     C                   Eval      Error = 'N'
     C                   Endif
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKCHGCDE - Checking for invalid charge codes                 *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ChkChgCde     Begsr
      *
     C                   Add       1             Idx
     C                   Add       1             Ind
 
      ** ? processing
 
     C     '?'           Scan      ChrgKey                                96
     C                   If        *In96
 
     C                   Call      'FT000940'
     C                   Parm      *Blanks       Code
 
     C                   Eval      ChrgKey = Code
     C                   Eval      ErrorFld = 'Y'
 
     C                   Else
 
      ** Payment Charge Definition
 
     C     ChrgKey       Setll     FTPCHGL0                               83
      *
     C                   If        *In83 = *Off AND ChrgKey <> Stars
     C                             AND ChrgKey <> *Blanks
     C                   Eval      ErrorFld = 'Y'
     C                   Eval      IndArray(Ind) = '1'
     C                   Eval      MsgDta = MsgArray(Idx)
     C                   Eval      MsgId = 'MIN0417'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   Endif
 
     C                   Endsr
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FILE2SCREEN - Moving file fields to screen fields             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     File2Screen   Begsr
 
     C                   Eval      SMTPY = MsgType
     C                   Eval      SMSET = MsgSet
     C                   Eval      SPDOCD = PDTOCD
     C                   Eval      SFXSCD = FXSPRS
     C                   Eval      SSWSCD = SWSTRC
     C                   Eval      SADVCD = ADVICH
     C                   Eval      SSWPCD = SWPCHG
     C                   Eval      SCABCD = CABCCO
     C                   Eval      STLXCD = TXCODE
     C                   Eval      SCHQCD = CHEQCG
     C                   Eval      STPHCD = TELPCH
     C                   Eval      SMI0CD = MISCCH
     C                   Eval      SCOLCD = COLLCH
     C                   Eval      SMI1CD = MICHG1
     C                   Eval      SCORCD = CORRCH
     C                   Eval      SMI2CD = MICHG2
     C                   Eval      SDEDCD = DEDUCH
     C                   Eval      SMI3CD = MICHG3
     C                   Eval      SFCCCD = FXCCCH
     C                   Eval      SMI4CD = MICHG4
     C                   Eval      STCOCD = TFCOCH
     C                   Eval      SMI5CD = MICHG5
 
     C                   Endsr
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SCREEN2FILE - Moving screen fields to file fields             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Screen2File   Begsr
 
     C                   Eval      MsgType = SMTPY
     C                   Eval      MsgSet = SMSET
     C                   Eval      PDTOCD = SPDOCD
     C                   Eval      FXSPRS = SFXSCD
     C                   Eval      SWSTRC = SSWSCD
     C                   Eval      ADVICH = SADVCD
     C                   Eval      SWPCHG = SSWPCD
     C                   Eval      CABCCO = SCABCD
     C                   Eval      TXCODE = STLXCD
     C                   Eval      CHEQCG = SCHQCD
     C                   Eval      TELPCH = STPHCD
     C                   Eval      MISCCH = SMI0CD
     C                   Eval      COLLCH = SCOLCD
     C                   Eval      MICHG1 = SMI1CD
     C                   Eval      CORRCH = SCORCD
     C                   Eval      MICHG2 = SMI2CD
     C                   Eval      DEDUCH = SDEDCD
     C                   Eval      MICHG3 = SMI3CD
     C                   Eval      FXCCCH = SFCCCD
     C                   Eval      MICHG4 = SMI4CD
     C                   Eval      TFCOCH = STCOCD
     C                   Eval      MICHG5 = SMI5CD
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * SNDMSG - Send Program Message                                 *
      *                                                               *
      * Called by: Validate, ChkChgCde                                *
      *                                                               *
      * Calls: AOCREPT                                                *
      *                                                               *
      *****************************************************************
     C     SndMsg        Begsr
 
      * Only write message if requested
 
     C                   If        MsgId <> *Blanks
     C                   CallB     'AOCREPT'
     C                   Parm                    MsgId
     C                   Parm                    MsgF
     C                   Parm                    MsgLib
     C                   Parm                    MsgDta
     C                   Parm                    MsgRel
     C                   Parm                    PSProcName
     C                   Parm                    FtMsgq
     C                   Parm                    FtMsgt
     C                   Endif
 
      * Reset message Id
 
     C                   Reset                   MsgDs
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        Begsr
 
     C     *Entry        Plist
     C                   Parm                    ActionCode
     C                   Parm                    MsgType
     C                   Parm                    MsgSet
     C                   Parm                    KeyPress
     C                   Parm                    SGncr
 
     ** Keylist for MEGNCRL0
 
     C     KTypeSet      Klist
     C                   Kfld                    KMsgType
     C                   Kfld                    KMsgSet
 
     C                   Eval      KMsgType = MsgType
     C                   Move      MsgSet        KMsgSet
 
     C                   Eval      ##PGM = PsProcName
     C                   Eval      SUSER = PSUser
     C                   Eval      SWSID = PSJobName
 
     ** If enquiry mode, protect screen fields
 
     C                   If        ActionCode = 'E'
     C                   Eval      *IN30 = *On
     C                   Else
     C                   Eval      *IN30 = *Off
     C                   Endif
 
      ** Reset error indicators
 
     C                   MoveA     '000000000000'*In(31)
     C                   MoveA     '00000000'    *In(43)
 
     C                   Eval      KeyPress = *Blanks
 
     C                   Endsr
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         Begsr
 
     C                   Dump
 
     C                   If        @RUN = *Blank
     C                   Eval      @RUN = 'Y'
 
     C                   CallB     'DBERRCTL'
 
     C                   Endif
 
     C                   Eval      *InU7 = *On
     C                   Eval      *InU8 = *On
     C                   Eval      *InLR = *On
     C                   Return
 
     C                   Endsr
 
      ********************************************************************
** MsgArray
Payment date offset code
FX spread code
S.W.I.F.T. standard charge code
Advice charge code
S.W.I.F.T. priority charge code
Costs abroad charge code
Telex charge code
Cheque charge code
Telephone charge code
Miscellaneous charge code
Collection charge code
Miscellaneous charge code 1
Correspondent's charge code
Miscellaneous charge code 2
Deductions charge code
Miscellaneous charge code 3
FX/Change commission charge code
Miscellaneous charge code 4
Transfer commission charge code
Miscellaneous charge code 5
