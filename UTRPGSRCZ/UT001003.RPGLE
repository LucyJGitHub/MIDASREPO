     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Source Parser')                               *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT001003 - Midas UT Source Parser                            *
      *                                                               *
      *  Function:  This module receives program names, parses their  *
      *             corresponding sources and checks for error codes  *
      *             and message files                                 *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CBF011  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    30         Msg Parameter Continuation                      *
      *    80         Distinct Program CHAIN                          *
      *    81         Error Message/Message Files List EOF            *
      *    82         Source Parser Work File EOF                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
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
      * GTSRCF - Get source file                                      *
      * PARSRC - Parse source for messages/message files              *
      * WRTOFL - Write all error messages/message files to file       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      * Midas UT Error Messages Usage File
     FUTERMUPD  O    E           K DISK
 
      * Midas UT Exceptions File
     FUTEREXPD  O    E           K DISK
 
      * Midas UT Distinct Programs File
     FUTDPGML0  UF   E           K DISK
 
      * Midas UT Source Parser Workfile
     FUTPARSPD  UF   E             DISK    USROPN
 
      * Midas UT Error Messages/Error Codes List - Distinct Message IDs
     FUTDMSGPD  IF   E             DISK    RENAME(UTDMSGF:UTERCF1)
 
      * Midas UT Error Messages/Error Codes List - All Message Files
     FUTDMSFPD  IF   E             DISK    RENAME(UTDMSFF:UTERCF2)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
 
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
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Program Info
     DFileFld          DS           191
     D PgmNam                  1     10
     D ErrCod                 43     49
     D ErrDesc                50    181
     D MsgFlNam              182    191
 
      ** Temp Program Name Holder
     DTmpName          S             10A
 
      ** Error Messages List Array
     DErrArrL          S              7A   DIM(32000)
 
      ** Message Files List Array
     DMsgFArrL         S             10A   DIM(500)
 
      ** Message Files List Array
     DPgms             S             10A   DIM(10)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
      ** Current Line
     DCurrLin          S             95A
 
      ** Current Line (RRN)
     D@LIN             S              6  0
 
      ** Message File Name Holder
     DMsgfNHld         S             10A
 
      ** Comment Monitor Field
     DCommInd          S              8A
 
      ** Error Message Holder for broken messages
     DErrMsg           S            132A
 
      ** Position Handler
     D@@POS            S              5  0
 
      ** Array Elements Count
     D@MFCNT           S              5  0
     D@EMCNT           S              5  0
 
      ** Array Index
     DI                S              5  0
 
      ** Program Array Index
     DX                S              2  0
 
      ** SNDMSG, SNDPGMMSG, SNDBRKMSG, SNDUSRMSG Flags
     D@SM              S              2  0
     D@SPM             S              2  0
     D@SBM             S              2  0
     D@SUM             S              2  0
 
     D@@FOUND          S              2  0
     DPlusInd          S              2  0
     D@@Str            S              2  0
     D@@End            S              2  0
 
      ** Batch Monitor Update Varibles
     D@LEN             S             15P 5
     D@CMD             S             50A
     D@OK              S              1A
 
      ** User Input Libraries
     DSrcLibs          S           2500A
 
      ** Program Batch of 10
     DBatPgms          S            101A
 
      ** Object Attribute Type
     DObjTyp           S             10A
 
      ** Batch Monitor Allocation Id
     DMonId            S              2A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C                   EXSR      LOADAR
 
     C                   Z-ADD     1             X
 
      ** Process sources of all programs in the batch
 
     C                   DOW       X <= 10 AND Pgms(X) <> *BLANKS
     C                   EVAL      PgmNam = Pgms(X)
 
      ** Get source file information and copy source to workfile
 
     C                   EXSR      GTSRCF
 
     C                   IF        PgmNam <> *BLANKS
 
      ** Find error messages/message files from records
 
     C                   Z-ADD     1             @LIN
     C                   OPEN      UTPARSPD
     C     @LIN          SETLL     UTPARSPD
     C                   READ      UTPARSPD                               82
     C                   DOW       *IN82 = *OFF
 
      ** Parse obtained source for Message Files and Error Messages
 
     C                   EXSR      PARSRC
     C                   EVAL      @LIN = @LIN + 1
 
     C     @LIN          SETLL     UTPARSPD
     C                   READ      UTPARSPD                               82
     C                   ENDDO
     C                   CLOSE     UTPARSPD
 
      ** Tag Program as Processed
 
     C
     C     PgmNam        CHAIN     UTDPGMF                            80
     C                   EVAL      DPPROC = 'Y'
     C                   UPDATE    UTDPGMF
     C                   ENDIF
 
      ** Set pointer to next program
 
     C                   ADD       1             X
     C                   ENDDO
     C                   EXSR      UPDFLG
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDFLG - Update Batch Monitor                                 *
      *                                                               *
      * Called by: Main Processing, *PSSR                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     UPDFLG        BEGSR
 
     C                   EVAL      @CMD = 'CHGDTAARA DTAARA(UTSPSTAT (' +
     C                                     MonId + ' 1)) VALUE(Y)'
     C                   EVAL      @LEN = 50
     C                   CALL      'QCMDEXC'
     C                   PARM                    @CMD
     C                   PARM                    @LEN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GTSRCF - Get source file information                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     GTSRCF        BEGSR
 
     C                   MOVE      PgmNam        TmpName
      ** Copy source to parser workfile
     C                   CALL      'UTC01003'
     C                   PARM                    PgmNam
     C                   PARM                    ObjTyp
     C                   PARM                    SrcLibs
 
      ** Write to exceptions file if source copy failed
     C                   IF        PgmNam = *BLANKS
     C                   EVAL      EXEXCP = 'Source not found: ' + TmpName
     C                   WRITE     UTEREXF
     C                   EVAL      EXEXCP = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PARSRC - Parse Source for error messages/message files        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     PARSRC        BEGSR
 
     C                   Z-ADD     0             @@POS
     C                   Z-ADD     0             @SM
     C                   Z-ADD     0             @SPM
     C                   Z-ADD     0             @SBM
     C                   Z-ADD     0             @SUM
     C                   Z-ADD     0             @@FOUND
     C                   MOVE      PACOMM        CommInd
     C                   MOVE      PASRCD        Currlin
     C                   EVAL      Currlin = %TRIM(Currlin)
     C
 
      ** Check if source line is active
 
     C                   IF        ObjTyp = 'RPG' OR ObjTyp = 'RPGLE'
     C                   EVAL      @@FOUND = %SCAN('C':CommInd)
     C                   ENDIF
     C                   EVAL      @@POS =  %SCAN('*':CommInd)
 
      ** Skip current line if inactive or not C specs (RPG/RPGLE only)
 
     C                   IF        @@POS = 0 AND @@FOUND <> 0
 
      ** Scan every line for error messages/message files
      ** SNDMSG, SNDUSRMSG, SNDBRKMSG, SNDPGMMSG
 
     C                   Z-ADD     0             @@FOUND
     C                   Z-ADD     0             PlusInd
     C                   Z-ADD     0             @@Str
     C                   Z-ADD     0             @@End
 
      ** If line is not a continutation
 
     C                   IF        *IN30 =  *OFF
     C                   EVAL      ErrMsg = *BLANKS
     C                   EVAL      @SM = %SCAN('SNDMSG':Currlin)
     C                   EVAL      @SPM = %SCAN('SNDPGMMSG':Currlin)
     C                   EVAL      @SBM = %SCAN('SNDBRKMSG':Currlin)
     C                   EVAL      @SUM = %SCAN('SNDUSRMSG':Currlin)
 
      ** Check if atleast one of four commands used
 
     C                   IF        @SM > 0 OR @SPM > 0 OR @SBM > 0 OR @SUM > 0
     C                   EVAL      @@FOUND = 1
     C                   ENDIF
 
     C                   IF        @@FOUND > 0
 
      ** Get Hardcoded Message from MSG parameter
 
     C                   EVAL      @@Str = %SCAN('MSG(':Currlin)
     C                   IF        @@Str > 0
     C                   EVAL      @@End = %SCAN(')':Currlin:@@Str)
     C                   EVAL      PlusInd = %SCAN('+':Currlin:@@Str)
 
     C                   EVAL      @@Str = @@Str + 4
     C                   IF        PlusInd > 0 AND @@End = 0
     C                   EVAL      *IN30 =  *ON
     C                   EVAL      @@End = PlusInd - @@Str
     C     @@End         SUBST     Currlin:@@Str ErrMsg
     C                   ELSE
     C                   EVAL      @@End = @@End - @@Str
     C     @@End         SUBST     Currlin:@@Str ErrMsg
 
     C                   EVAL      ErrDesc = ErrMsg
     C                   EVAL      ErrCod = *BLANKS
     C                   EVAL      MsgFlNam = *BLANKS
 
     C                   EXSR      WRTOFL
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
      ** If line is a continuation
 
     C                   EVAL      @@End = %SCAN(')':Currlin)
     C                   EVAL      *IN30 =  *OFF
 
     C                   EVAL      ErrDesc = ErrMsg + %SUBST(Currlin:1:@@End)
     C                   EVAL      ErrCod = *BLANKS
     C                   EVAL      MsgFlNam = *BLANKS
 
     C                   EXSR      WRTOFL
     C                   ENDIF
 
      ** Error messages
 
     C                   EVAL      @@POS = 1
 
     C                   DOU       @@POS > @EMCNT
     C                   EVAL      @@FOUND =  %SCAN(ErrArrL(@@POS):Currlin)
 
     C                   IF        @@FOUND > 0
     C                   EVAL      ErrCod = ErrArrL(@@POS)
     C                   EVAL      ErrDesc = *BLANKS
     C                   EVAL      MsgFlNam = *BLANKS
 
     C                   EXSR      WRTOFL
     C                   ENDIF
 
     C                   EVAL      @@POS = @@POS + 1
     C                   ENDDO
 
      ** Message Files
 
     C                   EVAL      @@POS = 1
 
     C                   DOU       @@POS > @MFCNT
     C                   EVAL      MsgfNHld = %SUBST(MsgfArrL(@@POS):3)
     C                   EVAL      @@FOUND = %SCAN(MsgfNHld:Currlin)
 
     C                   IF        @@FOUND = 0
     C                   EVAL      @@FOUND = %SCAN(MsgfArrL(@@POS):Currlin)
     C                   ENDIF
 
     C                   IF        @@FOUND > 0
     C                   EVAL      ErrCod = *BLANKS
     C                   EVAL      ErrDesc = *BLANKS
     C                   EVAL      MsgFlNam = MsgfArrL(@@POS)
 
     C                   EXSR      WRTOFL
     C                   ENDIF
 
     C                   EVAL      @@POS = @@POS + 1
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WRTOFL - Write all error messages/message files to file       *
      *                                                               *
      * Called by: PARSRC                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     WRTOFL        BEGSR
 
     C                   EVAL      ERCPGM = PgmNam
     C                   EVAL      ERERID = ErrCod
     C                   EVAL      ERERRD = ErrDesc
     C                   EVAL      ERMSGF = MsgFlNam
     C                   WRITE     UTERMUF
     C                   EVAL      ErrCod   = *BLANKS
     C                   EVAL      ErrDesc  = *BLANKS
     C                   EVAL      MsgFlNam = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LOADAR - Load error messages, message files and programs      *
      *             programs arrays                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     LOADAR        BEGSR
 
     C     1             SETLL     UTERCF1
     C                   READ      UTERCF1                                81
     C                   Z-ADD     1             I
 
     C                   DOW       *IN81 = *OFF
 
      ** Populate error messages array
 
     C                   EVAL      ErrArrL(I) = DMMIDR
     C                   ADD       1             I
     C                   READ      UTERCF1                                81
     C                   ENDDO
     C                   EVAL      @EMCNT = I - 1
 
     C     1             SETLL     UTERCF2
     C                   READ      UTERCF2                                81
     C                   Z-ADD     1             I
 
     C                   DOW       *IN81 = *OFF
 
      ** Populate message files array
 
     C                   EVAL      MsgfArrL(I) = DMFILE
     C                   ADD       1             I
     C                   READ      UTERCF2                                81
     C                   ENDDO
     C                   EVAL      @MFCNT = I - 1
 
     C                   MOVE      'X'           START             1
     C                   Z-ADD     1             I
     C                   Z-ADD     1             @@POS
 
     C                   DOW       START <> '*' AND START <> ' '
 
     C                   EVAL      Pgms(I) = %SUBST(BatPgms:@@POS:10)
     C                   ADD       1             I
     C                   ADD       10            @@POS
     C                   EVAL      START = %SUBST(BatPgms:@@POS:1)
 
     C                   ENDDO
     C                   Z-ADD     0             @@POS
 
     C                   ENDSR
      *****************************************************************
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
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    SrcLibs
     C                   PARM                    BatPgms
     C                   PARM                    MonId
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      FileFld = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EXSR      UPDFLG
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
