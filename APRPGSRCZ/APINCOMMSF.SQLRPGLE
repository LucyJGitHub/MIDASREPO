     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*S*D****RPGBASEMOD****************************************************                     MD039105
/*STD *  RPGSQLMOD                                                    *                     MD039105
/*EXI *  TEXT('Midas AP Process incoming messages from file')         *
      *****************************************************************
      *                                                               *
      *  Midas - API Interface Module                                 *
      *                                                               *
      *  APINCOMMSF - Midas API Process incoming messages from file   *
      *                                                               *
      *  Function:  This program processes messages received via the  *
      *             file APITRANSPD.                                  *
      *             Messages are held on the file as character        *
      *             strings, and must be separated into MM fields     *
      *             using data structures. The program will run in    *
      *             batch. Transaction details are passed to the      *
      *             relevant API for validation then storage in the   *
      *             Midas database.                                   *
      *                                                               *
      *  Calls - APPARSMSG - Set up Transaction and Settlement Data   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD039105           Date 06Jun16               *
      *  Prev Amend No. CSW216             Date 14Mar16               *
      *                 CPK030             Date 11Apr14               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSW213             Date 03Jun13               *
      *                 CFT120             Date 28Sep12               *
      *                 CFT039             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25877           Date 03Sep09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CAP186C            Date 28Jan08               *
      *                 248330             Date 05Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241470             Date 07Sep06               *
      *                 240283             Date 07Jun06               *
      *                 BUG9887            Date 12Jan06               *
      *                 BUG10160           Date 16Jan06               *
      *                 CER001             Date 25Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL018             Date 03Feb04               *
      *                 222373             Date 28Oct03               *
      *                 CAP083  *CREATE    Date 20Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039105 - Data truncation encountered when trying to insert *
      *             CUSD MQ and SOAP transaction with UDF fields      *
      *           - Applied for MD-39420.                             *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CPK030 - Clean up of deliverable data library.               *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL094 - Enhance Receive Settlement Instructions (Recompile) *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *           Amendment done to accommodate longer data           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25877 - Data is always truncated and ends in ACUD repair  *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CAP186C - MQ Enabled CB APIs. Buffer length of APOUTPUTPD    *
      *           increased to 32000. Renamed buffer field of this    *
      *           file to avoid conflict with other buffers used in   *
      *           this program                                        *
      *  248330 - APISERVFL dumps. SETON LR at *INZSR when no data to *
      *           process to ensure that *INZSR will be executed      *
      *           every run to avoid commitment control error.        *
      *  241470 - Applied fix BUG9887.                                *
      *  240283 - Apply BUG10160.                                     *
      *           Fix applied annotated as BUG10160.                  *
      *  BUG9887 - No information passed to IRCIRSCTL at all...       *
      *  BUG10160 - Locking the wrong dataarea                        *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  222373 - Correct parameters on program calls                 *
      *  CAP083 - APISERVER File Adapter                              *
      *                                                               *
      *****************************************************************
      /EJECT
 
      ** API Transaction file
     FAPITRANSPDUF   E             DISK
 
      ** File to log received data
     F***APOUTPUTPDO*   E           K DISK                                                   CAP186C
     F***APOUTPUTPDO    E           K DISK    PREFIX(O_)                            CAP186C MD039105
 
      ** File to log unauthorised access attempts
     FAPUNAUTHPDO    E           K DISK    USROPN
 
      ** File to log details of message after exception error
     FAPEXCPERPDO    E           K DISK
 
      ** File to log job details
     FAPIJOBL0  O    E           K DISK    USROPN
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
     D JournalEnt      DS
      * Standard fields on all journal entries
     D  Filler01                      5A
     D  JrnSeqn                      10A
     D  JrnCode                       1A
     D  JrnEntType                    2A
     D  Filler02                     38A
 
     D ControlInf      DS
     D  CTRLInfo1                     1
 
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
 
      ** Do NOT change the following constant values. Alterations
      ** here require changes to PC applications.
 
      * Don't need little letters...
     D CHARSET         C                   'ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZABCDEFGHIJKLMN-
     D                                     OPQRSTUVWXYZ12345678-
     D                                     90 '
     D CIPHER          C                   '156RS2czIj9BY aNDrEw-
     D                                     JAmesC0oKunlO4G3i-
     D                                     XhW8pxQftVvTPLHgFdby-
     D                                     7qkZUM'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** Incoming message header format
     D APHEAD        E DS                  EXTNAME(APHEADPD)
 
      ** Data structure for incoming message formats
     D*BUFFER***       DS          6000                                                       CFT039
     D*BUFFER***       DS         12000                                                CFT039 CSW213
     D BUFFER          DS         29997                                                       CSW213
     D  TYPE                   1      8
     D  USERID                33     42
     D  PASSWORD              43     52
 
      ** The include below brings in the return code structure that
      ** is used in calls to OS/400 APIs.
     D/COPY QSYSINC/QRPGLESRC,QUSEC
      * API Error code parameter
 
     D PaySttmt      E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions
     D RecSttmt      E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions
     D FRASttmt      E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions
 
     D PayStmtV      E DS                  EXTNAME(SDESSPPD)  PREFIX(V)
      * Pay Settlement Instructions
     D RecStmtV      E DS                  EXTNAME(SDESSRPD)  PREFIX(V)
      * Receive Settlement Instructions
 
     D PayStmtM      E DS                  EXTNAME(SDESSPPD)  PREFIX(M)
      * Pay Settlement Instructions
     D RecStmtM      E DS                  EXTNAME(SDESSRPD)  PREFIX(M)
      * Receive Settlement Instructions
 
     D  DLRIS1In     E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D  DLRIS2In     E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D  DLRIS3In     E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D  DLRIS4In     E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D  SDSW13In     E DS                  EXTNAME(SDSW13PD)                                  CSW213
     D                                     PREFIX(S13)                                        CSW213
                                                                                              CSW213
     D InSwift2013     DS                                                                     CSW213
     D   DLRIS1DS                          LIKE(DLRIS1In)                                     CSW213
     D   DLRIS2DS                          LIKE(DLRIS2In)                                     CSW213
     D   DLRIS3DS                          LIKE(DLRIS3In)                                     CSW213
     D   DLRIS4DS                          LIKE(DLRIS4In)                                     CSW214
      * Reporting Information                                                                 CSW213
                                                                                              CSW213
     D Trans9999_2     DS          9999                                                       CSW213
     D  SDSW13Ds                           LIKE(SDSW13In)                                     CSW213
     D  Trans2Fil8942              8942                                                       CSW213
                                                                                              CSW213
     D Trans9999_3     DS          9999                                                       CSW213
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** Real message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D MsgID           S                   LIKE(#MsgID)
     D MsgF            S             10A
 
     D******Object          S             10A   INZ('APISERVER')                            BUG10160
     D Object          S             10A   INZ('APISERVFL')                                 BUG10160
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
 
      ** Error message for sending to the operator
     D MQError         S            132A
 
      ** Other Depot Details for Securities Customer.
      ** This totals to 150 additional other depot details from the incoming message.
     D OthDData        S           4755A
 
      ** Work variable used by CSW209                                                         CSW209
     D TRANS9A         S           1000A                                                      CSW209
     D TRANS9B         S           1000A                                                      CSW209
     D Trans3A         S           1000A                                                      CFT120
     D Trans5A         S           1000A                                                      CFT120
                                                                                            MD039105
     D O_BUFFER        S          32000                                                     MD039105
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ****************************************************************
      *                                                              *
      *  Main processing                                             *
      *                                                              *
      ****************************************************************
 
      ** Loop to read all records from API Transaction file
 
     C                   READ      APITRANSPD                             91
 
     C     *IN91         DOWEQ     *OFF
 
      ** End job if Shutdown command received
     C                   IF        TYPE = 'SHUTDOWN'
     C                   DELETE    APITRANSD0
     C                   EVAL      CTRLInfo1 = '9'
     C                   LEAVE
     C                   ENDIF
 
      ** If an exception error occurred when validating the last
      ** message, then the rollback will cause the same message to
      ** be retrieved again.
      ** In this case, read the message, output to an error logging
      ** file and retrieve the next message.
      ** The module in error is stored in the return code on the
      ** APHEAD parameter.
 
     C     APRETCODE     IFNE      *BLANKS
     C                   WRITE     APEXCPERD0
     C                   EVAL      APRETCODE = *BLANKS
      ** Perform a commit to ensure that message cannot be read again
     C                   COMMIT
     C                   ELSE
 
      ** If required, validate the Profile / Password
     C                   IF        GHPWCR = 'Y'
     C                   EXSR      ValPrfPwd
     C                   ENDIF
 
      ** QUESI is the Error MSGID from the API call
      **   N.B. QUESI will always be blank if the checking is off
     C     QUSEI         IFEQ      *BLANKS
 
     C                   EXSR      VALID8
 
      ** The PrfHandle must be released to avoid hitting the job limit:
      ** 25574 simultaneous handles.
     C                   IF        GHPWCR = 'Y'
     C                   CALL      'QSYRLSPH'
     C                   PARM                    PrfHandle
     C                   ENDIF
 
     C                   ELSE
 
      ** Send an error message for the  Profile / Password
     C                   EXSR      PrfPwdErr
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   DELETE    APITRANSD0
     C                   READ      APITRANSPD                             91
     C                   ENDDO
 
      ** Perform a commit to ensure that the 'Shutdown' message is removed
      ** from the queue.
     C                   COMMIT
 
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      ****************************************************************
      *                                                              *
      *  Validate deal type                                          *
      *                                                              *
      ****************************************************************
     C     VALID8        BEGSR
 
     C                   MOVEL     BUFFER        APHEAD
 
     C     APMIDUSR      IFEQ      *BLANKS
     C                   MOVEL     PSUSER        APMIDUSR
     C                   ENDIF
 
      ** Log incoming data
     C                   MOVEL     *BLANKS       O_BUFFER                                    CAP186C
     C                   MOVEL     BUFFER        O_BUFFER                                    CAP186C
     C**********         WRITE     APOUTPUTD0                                               MD039105
                                                                                            MD039105
     C/exec SQL                                                                             MD039105
     C+ insert into APOUTPUTPD                                                              MD039105
     C+ (                                                                                   MD039105
     C+   BUFFER                                                                            MD039105
     C+ )                                                                                   MD039105
     C+ values                                                                              MD039105
     C+ (                                                                                   MD039105
     C+   :O_BUFFER                                                                         MD039105
     C+ )                                                                                   MD039105
     C/end-exec                                                                             MD039105
 
      ** Set up the Transaction & Settlement DS's
 
     C                   CALLB     'APPARSMSG'
     C                   PARM                    BUFFER
     C                   PARM                    TRANS1          500
     C                   PARM                    TRANS1A        1000                         BUG9887
     C                   PARM                    TRANS1B        1500                        BUG25877
     C                   PARM                    TRANS2          500
     C                   PARM                    TRANS3          500
     C                   PARM                    TRANS3A                                      CFT120
     C                   PARM                    TRANS4          500
     C                   PARM                    TRANS5          500
     C                   PARM                    TRANS5A                                      CFT120
     C                   PARM                    TRANS6          500
     C                   PARM                    TRANS7          500
     C                   PARM                    TRANS8          500
     C                   PARM                    TRANS9          500                          222373
     C                   PARM                    TRANS9A                                      CSW209
     C                   PARM                    TRANS9B                                      CSW209
     C                   PARM                    TRANS10         500                          262664
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    PayStmtV
     C                   PARM                    RecStmtV
     C                   PARM                    PayStmtM
     C                   PARM                    RecStmtM
     C                   PARM                    InfData         500
     C                   PARM                    RegData         500                          CER001
     C                   PARM                    ExtData         500
     C                   PARM                    OthDData
     C                   PARM                    InSwift2013                                  CSW213
     C                   PARM                    Trans9999_2                                  CSW213
     C                   PARM                    Trans9999_3                                  CSW213
     C                   PARM                    Bypass            1
 
      ** Any unrecognised message types are written to the error file
     C     Bypass        IFEQ      'Y'
     C                   WRITE     APEXCPERD0
     C                   COMMIT
     C                   ENDIF
 
      ** Load the entire message header into the API Dump data area so that
      **  dumps in any lower level modules will include the key information
     C     *Lock         IN        APDump
     C                   MOVEL     APHEAD        APDUMP
     C                   OUT       APDump
 
      ** Validate
 
      ** Call submodule to apply override and call appropriate
      ** validation program
     C     Bypass        IFEQ      'N'                                                        CPK015
     C                   CALLB     'APCCALLCTL'
     C                   PARM                    TYPE
     C                   PARM                    APHEAD
     C                   PARM                    TRANS1
     C                   PARM                    TRANS1A        1000                         BUG9887
     C                   PARM                    TRANS1B        1500                        BUG25877
     C                   PARM                    TRANS2
     C                   PARM                    TRANS3
     C                   PARM                    TRANS3A                                      CFT120
     C                   PARM                    TRANS4
     C                   PARM                    TRANS5
     C                   PARM                    TRANS5A                                      CFT120
     C                   PARM                    TRANS6
     C                   PARM                    TRANS7
     C                   PARM                    TRANS8
     C                   PARM                    TRANS9                                       222373
     C                   PARM                    TRANS9A                                      CSW209
     C                   PARM                    TRANS9B                                      CSW209
     C                   PARM                    TRANS10         500                          262664
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    PayStmtV
     C                   PARM                    RecStmtV
     C                   PARM                    PayStmtM
     C                   PARM                    RecStmtM
     C                   PARM                    InfData
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData
     C                   PARM                    OthDData
     C                   PARM                    InSwift2013                                  CSW213
     C                   PARM                    Trans9999_2                                  CSW213
     C                   PARM                    Trans9999_3                                  CSW213
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
     C                   ENDIF                                                                CPK015
 
     C                   ENDSR
      /EJECT
      ****************************************************************
      *                                                              *
      *  Validate the profile & password                             *
      *                                                              *
      ****************************************************************
     C     ValPrfPwd     BEGSR
 
      ** Decode the APPASSWORD field in preparation for the validation
     C                   EXSR      DECODE
 
      ** The following call is an OS/400 API which will validate
      ** the incoming message parameters of UserId and Password.
      ** If the incoming details were valid, then the field QUSEI
      ** in the Error Code structure will be blank. The profile
      ** handle must be explicitly released.
      ** If the incoming details were invalid, then the message is
      ** logged to APUNAUTHPD, and a message is sent to QSYSOPR.
      ** Unauthorised information will not be logged to APOUTPUTPD, as
      ** this file is updated during the VALID8 subroutine.
 
     C                   MOVE      *BLANKS       PrfHandle
     C                   RESET                   QUSEC
 
     C                   CALL      'QSYGETPH'
     C                   PARM                    USERID
     C                   PARM                    PASSWORD
     C                   PARM                    PrfHandle        12
     C                   PARM                    QUSEC
 
      ** The UserID and Password fields are now irrelevant, and are
      ** starred out to prevent them appearing on log files and dumps.
     C                   MOVE      '**********'  APPASSWORD
     C                   MOVE      '**********'  PASSWORD
 
     C                   ENDSR
      /EJECT
      ****************************************************************
      *                                                              *
      *  Send Profile / Password error message                       *
      *                                                              *
      ****************************************************************
     C     PrfPwdErr     BEGSR
 
      ** Send message to QSYSOPR warning of attempted unauthorised
      ** access to Midas APIs
 
 
     C                   CLEAR                   MQError
     C                   EVAL      MsgF = 'APMSGF'
     C                   IF        APUserID = *Blanks
     C                   EVAL      MsgID = 'API0002'
     C                   ELSE
     C                   EVAL      MsgID = 'API0001'
     C                   END
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQError
     C                   PARM                    MsgID
     C                   PARM                    MsgF
 
     C                   OPEN      APUNAUTHPD
     C                   WRITE     APUNAUTHD0
     C                   CLOSE     APUNAUTHPD
 
 
      ** Commit the MQGET operation
     C                   COMMIT
 
     C                   ENDSR
      /EJECT
      ****************************************************************
      *                                                              *
      *  Decode the password field                                   *
      *                                                              *
      ****************************************************************
     C     DECODE        BEGSR
 
     C                   MOVE      *BLANK        CURRCHAR          1
     C                   MOVE      *BLANKS       DECODED          10
     C                   Z-ADD     0             W                 1 0
     C                   Z-ADD     0             X                 3 0
     C                   Z-ADD     0             Y                 2 0
     C                   Z-ADD     1             Z                 2 0
      * W is 1 or 0 and says how blanks to pad the CAT to the decoded
      *  passwork with, depending upon whether the previous char was blank
      * X is the position in the clear or enciphered constant,
      * Y is a work field
      * Z is the position in the incoming (enciphered) password
 
     C     Z             DOWLT     11
 
      ** Get the next character in the password
     C     1             SUBST     PASSWORD:Z    CURRCHAR
 
      ** Look up the cipher value
     C     CURRCHAR      SCAN      CIPHER        X
 
      ** Ignore unrecognised characters
     C     X             IFNE      0
 
     C     Z             MULT      2             Y
     C                   SUB       Y             X
     C     X             IFLE      0
     C                   ADD       63            X
     C                   ENDIF
 
      ** Substitute in the correct value
     C     1             SUBST     CHARSET:X     CURRCHAR
 
      ** Drop out if character is a blank
     C     CURRCHAR      IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   CAT       CURRCHAR:W    DECODED
 
      ** Cater for special case of blanks
     C     CURRCHAR      IFEQ      *BLANK
     C                   Z-ADD     1             W
     C                   ELSE
     C                   Z-ADD     0             W
     C                   ENDIF
 
     C                   ADD       1             Z
 
     C                   ENDDO
 
     C                   MOVEL     DECODED       PASSWORD
     C                   ENDSR
      /EJECT
      ****************************************************************
      *                                                              *
      *  Initialisation                                              *
      *                                                              *
      ****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf
 
      * If the first byte of Control Information is 0, no data has been
      *  passed so simply return
 
     C                   IF        CTRLInfo1 = '0'
     C                   SETON                                        LR                      248330
     C                   RETURN
     C                   ENDIF
 
      *  Lock allocation data area
 
      *   The data area is allocated *SHRRD here.
      *   The function to submit this tries to get a *EXCL lock.
 
      *                         Submitter
      *                 Lock      Lock     Submitter
      *      Status    Status   Successful   Action
      *      ------    ------   ---------- ---------
      *   Not running  None        Yes      Submit this
 
      *   Running      *SHRRD      No        None
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      ** Set up Midas SPF Environment
     C                   CALL      'SFC0401'
 
      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
 
      ** Check for success, else bomb
     C     ReturnCde     IFNE      *BLANKS
     C                   ENDIF
 
      ** Log job start-up in jobs file
     C                   OPEN      APIJOBL0
     C                   WRITE     JOBRCD
     C                   CLOSE     APIJOBL0
 
      ** Set up the procedure/module/program names for calls to the
      **  validation modules
     C                   EVAL      #ProcPgm  = PSProcPgm
     C                   EVAL      #ProcMod  = PSProcMod
     C                   EVAL      #ProcName = PSProcName
 
      ** Call CL to start commitment control
     C                   CALLB     'ZACSCMTCTL'
 
      ** Access API ICD via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ***Ensure*that*all*the*API*data*queues*exist*                                           CPK030
     C**********         CLEAR                   ReturnCode                                   CPK030
     C**********         CALL      'APCRTDTAQS'                                               CPK030
     C**********         PARM                    ReturnCode                                   CPK030
 
     C                   ENDSR
      /EJECT
      ****************************************************************
      **------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------------
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
