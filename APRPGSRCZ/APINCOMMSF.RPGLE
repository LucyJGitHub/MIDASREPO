000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2003')
000300200528      *****************************************************************
000400200528/*S*D****RPGBASEMOD****************************************************                     MD039105
000500200528/*STD *  RPGSQLMOD                                                    *                     MD039105
000600200528/*EXI *  TEXT('Midas AP Process incoming messages from file')         *
000700200528      *****************************************************************
000800200528      *                                                               *
000900200528      *  Midas - API Interface Module                                 *
001000200528      *                                                               *
001100200528      *  APINCOMMSF - Midas API Process incoming messages from file   *
001200200528      *                                                               *
001300200528      *  Function:  This program processes messages received via the  *
001400200528      *             file APITRANSPD.                                  *
001500200528      *             Messages are held on the file as character        *
001600200528      *             strings, and must be separated into MM fields     *
001700200528      *             using data structures. The program will run in    *
001800200528      *             batch. Transaction details are passed to the      *
001900200528      *             relevant API for validation then storage in the   *
002000200528      *             Midas database.                                   *
002100200528      *                                                               *
002200200528      *  Calls - APPARSMSG - Set up Transaction and Settlement Data   *
002300200528      *                                                               *
002400200528      *  (c) Finastra International Limited 2003                      *
002500200528      *                                                               *
002600200604      *  Last Amend No. 248812B            Date 22MAY20               *
002700200604      *  Prev Amend No. 248812A            Date 22MAY20               *
002800200604      *                 248812             Date 22May20               *
002900200604      *                 CSD102             Date 08Jan19               *
003000200528      *                 MD046248           Date 27Oct17               *
003100200528      *                 MD039105           Date 06Jun16               *
003200200528      *                 CSW216             Date 14Mar16               *
003300200528      *                 CPK030             Date 11Apr14               *
003400200528      *                 CSW214             Date 25Nov14               *
003500200528      *                 CDL094             Date 11Jun14               *
003600200528      *                 CSW213             Date 03Jun13               *
003700200528      *                 CFT120             Date 28Sep12               *
003800200528      *                 CFT039             Date 28Sep12               *
003900200528      *                 CSF011A            Date 28Nov11               *
004000200528      *                 CER059             Date 19Jul10               *
004100200528      *                 BUG25877           Date 03Sep09               *
004200200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
004300200528      *                 CSW209             Date 01Apr09               *
004400200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
004500200528      *                 256564             Date 17Sep08               *
004600200528      *                 CAP186C            Date 28Jan08               *
004700200528      *                 248330             Date 05Jul07               *
004800200528      * Midas Plus 1.4 Base ------------------------------------------*
004900200528      * Midas Plus 1.3 ----------- Base ------------------------------*
005000200528      *                 241470             Date 07Sep06               *
005100200528      *                 240283             Date 07Jun06               *
005200200528      *                 BUG9887            Date 12Jan06               *
005300200528      *                 BUG10160           Date 16Jan06               *
005400200528      *                 CER001             Date 25Apr05               *
005500200528      *                 CLE031             Date 26Apr05               *
005600200528      *                 CDL018             Date 03Feb04               *
005700200528      *                 222373             Date 28Oct03               *
005800200528      *                 CAP083  *CREATE    Date 20Feb03               *
005900200528      *                                                               *
006000200528      *---------------------------------------------------------------*
006100200528      *                                                               *
006200200528      *  248812B- Another MSGW due to non-existence of other data area*
006300200528      *  248812A- Another MSGW due to non-existence of ZBRU1 not ZVRU1*
006400200528      *  248812 - Error on APISERVFL when Response Mode S A S on MQ   *
006500200528      *           Message. Dataara ZBRU and ZOBU not found.           *
006600200528
006700200528      *  CSD102 - Password Length Extension                           *
006800200528      *  MD046248 - Finastra Rebranding                               *
006900200528      *  MD039105 - Data truncation encountered when trying to insert *
007000200528      *             CUSD MQ and SOAP transaction with UDF fields      *
007100200528      *           - Applied for MD-39420.                             *
007200200528      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
007300200528      *  CPK030 - Clean up of deliverable data library.               *
007400200528      *  CSW214 - SWIFT Changes 2014                                  *
007500200528      *  CDL094 - Enhance Receive Settlement Instructions (Recompile) *
007600200528      *  CSW213 - SWIFT Changes 2013                                  *
007700200528      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
007800200528      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
007900200528      *           Amendment done to accommodate longer data           *
008000200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
008100200528      *            (Recompile)                                        *
008200200528      *  CER059 - German Feature Upgrade to Delhi                     *
008300200528      *  BUG25877 - Data is always truncated and ends in ACUD repair  *
008400200528      *  CSW209 - SWIFT 2009 Changes                                  *
008500200528      *  256564 - Recompile due to PF changes done by fix 256330      *
008600200528      *  CAP186C - MQ Enabled CB APIs. Buffer length of APOUTPUTPD    *
008700200528      *           increased to 32000. Renamed buffer field of this    *
008800200528      *           file to avoid conflict with other buffers used in   *
008900200528      *           this program                                        *
009000200528      *  248330 - APISERVFL dumps. SETON LR at *INZSR when no data to *
009100200528      *           process to ensure that *INZSR will be executed      *
009200200528      *           every run to avoid commitment control error.        *
009300200528      *  241470 - Applied fix BUG9887.                                *
009400200528      *  240283 - Apply BUG10160.                                     *
009500200528      *           Fix applied annotated as BUG10160.                  *
009600200528      *  BUG9887 - No information passed to IRCIRSCTL at all...       *
009700200528      *  BUG10160 - Locking the wrong dataarea                        *
009800200528      *  CER001 - LUX Upgrade to MidasPlus                            *
009900200528      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
010000200528      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
010100200528      *           (Recompile)                                         *
010200200528      *  222373 - Correct parameters on program calls                 *
010300200528      *  CAP083 - APISERVER File Adapter                              *
010400200528      *                                                               *
010500200528      *****************************************************************
010600200528      /EJECT
010700200528
010800200528      ** API Transaction file
010900200528     FAPITRANSPDUF   E             DISK
011000200528
011100200528      ** File to log received data
011200200528     F***APOUTPUTPDO*   E           K DISK                                                   CAP186C
011300200528     F***APOUTPUTPDO    E           K DISK    PREFIX(O_)                            CAP186C MD039105
011400200528
011500200528      ** File to log unauthorised access attempts
011600200528     FAPUNAUTHPDO    E           K DISK    USROPN
011700200528
011800200528      ** File to log details of message after exception error
011900200528     FAPEXCPERPDO    E           K DISK
012000200528
012100200528      ** File to log job details
012200200528     FAPIJOBL0  O    E           K DISK    USROPN
012300200528
012400200528      *****************************************************************
012500200528      ** +--------------------------------------+
012600200528      ** ¦ Automatically included D-specs       ¦
012700200528      ** ¦ ==============================       ¦
012800200528      ** +--------------------------------------+
012900200528      **
013000200528      ** Standard D-specs
013100200528      ** ================
013200200528      **
013300200528      ** The following /COPY line includes the LDA layout,
013400200528      ** the copyright array definition,
013500200528      ** and the following named constants:
013600200528      **    True       logical = *on (for indcator processing)
013700200528      **    False      logical = *off (for indcator processing)
013800200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
013900200528      **                                    handler)
014000200528      ** and the following variables:
014100200528      **    RunBefore  1A (for the PSSR)
014200200528
014300200528     D/COPY ZACPYSRC,STD_D_SPEC
014400200528
014500200528      ** Program Status Data Structure
014600200528      ** =============================
014700200528      ** The following /COPY line includes all the defined fields in the
014800200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
014900200528     D/COPY ZACPYSRC,PSDS
015000200528
015100200528      ** +--------------------------------------+
015200200528      ** ¦ End of automatically included D-specs¦
015300200528      ** ¦ =====================================¦
015400200528      ** +--------------------------------------+
015500200528
015600200528     D JournalEnt      DS
015700200528      * Standard fields on all journal entries
015800200528     D  Filler01                      5A
015900200528     D  JrnSeqn                      10A
016000200528     D  JrnCode                       1A
016100200528     D  JrnEntType                    2A
016200200528     D  Filler02                     38A
016300200528
016400200528     D ControlInf      DS
016500200528     D  CTRLInfo1                     1
016600200528
016700200528      *****************************************************************
016800200528      /EJECT
016900200528      *****************************************************************
017000200528
017100200528      ** +--------------------------------------+
017200200528      ** ¦ Manually included D-specs            ¦
017300200528      ** ¦ =========================            ¦
017400200528      ** +--------------------------------------+
017500200528
017600200528      ** +--------------------------------------+
017700200528      ** ¦ Named constants                      ¦
017800200528      ** ¦ ===============                      ¦
017900200528      ** +--------------------------------------+
018000200528
018100200528      ** Do NOT change the following constant values. Alterations
018200200528      ** here require changes to PC applications.
018300200528
018400200528      * Don't need little letters...
018500200528     D CHARSET         C                   'ABCDEFGHIJKLMNOPQRST-
018600200528     D                                     UVWXYZABCDEFGHIJKLMN-
018700200528     D                                     OPQRSTUVWXYZ12345678-
018800200528     D                                     90 '
018900200528     D CIPHER          C                   '156RS2czIj9BY aNDrEw-
019000200528     D                                     JAmesC0oKunlO4G3i-
019100200528     D                                     XhW8pxQftVvTPLHgFdby-
019200200528     D                                     7qkZUM'
019300200528
019400200528      ** +--------------------------------------+
019500200528      ** ¦ Arrays and Data Structures           ¦
019600200528      ** ¦ ==========================           ¦
019700200528      ** +--------------------------------------+
019800200528
019900200528     D SDAPI         E DS                  EXTNAME(SDAPIPD)
020000200528      ** External DS for API ICD
020100200528
020200200528     D DSFDY         E DS                  EXTNAME(DSFDY)
020300200528      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
020400200528
020500200528      ** Incoming message header format
020600200528     D APHEAD        E DS                  EXTNAME(APHEADPD)
020700200528
020800200528      ** Data structure for incoming message formats
020900200528     D*BUFFER***       DS          6000                                                       CFT039
021000200528     D*BUFFER***       DS         12000                                                CFT039 CSW213
021100200528     D BUFFER          DS         29997                                                       CSW213
021200200528     D  TYPE                   1      8
021300200528     D  USERID                33     42
021400200528     D**PASSWORD              43     52                                                       CSD102
021500200528     D  PASSWORD              43    170                                                       CSD102
021600200528      ***Command*to*create*dtaara*ZBRU,*ZOBU*and*ZVRU1*in*QTEMP****                   248812 248812A
021700200528      ** Command to create dtaara ZBRU, ZOBU and ZBRU1 in QTEMP                              248812A
021800200528      ** Increase array length for creation of other data areas                              248812B
021900200528     D*CRT@*****       S             50    DIM(3) CTDATA PERRCD(1)                            248812
022000200528     D CRT@            S             80    DIM(6) CTDATA PERRCD(1)                           248812B
022100200528
022200200528      ** The include below brings in the return code structure that
022300200528      ** is used in calls to OS/400 APIs.
022400200528     D/COPY QSYSINC/QRPGLESRC,QUSEC
022500200528      * API Error code parameter
022600200528
022700200528     D PaySttmt      E DS                  EXTNAME(SDESSPPD)
022800200528      * Pay Settlement Instructions
022900200528     D RecSttmt      E DS                  EXTNAME(SDESSRPD)
023000200528      * Receive Settlement Instructions
023100200528     D FRASttmt      E DS                  EXTNAME(SDESSFPD)
023200200528      * FRA/IRS Settlement Instructions
023300200528
023400200528     D PayStmtV      E DS                  EXTNAME(SDESSPPD)  PREFIX(V)
023500200528      * Pay Settlement Instructions
023600200528     D RecStmtV      E DS                  EXTNAME(SDESSRPD)  PREFIX(V)
023700200528      * Receive Settlement Instructions
023800200528
023900200528     D PayStmtM      E DS                  EXTNAME(SDESSPPD)  PREFIX(M)
024000200528      * Pay Settlement Instructions
024100200528     D RecStmtM      E DS                  EXTNAME(SDESSRPD)  PREFIX(M)
024200200528      * Receive Settlement Instructions
024300200528
024400200528     D  DLRIS1In     E DS                  EXTNAME(DLRIS1PD)                                  CSW213
024500200528     D  DLRIS2In     E DS                  EXTNAME(DLRIS2PD)                                  CSW213
024600200528     D  DLRIS3In     E DS                  EXTNAME(DLRIS3PD)                                  CSW213
024700200528     D  DLRIS4In     E DS                  EXTNAME(DLRIS4PD)                                  CSW214
024800200528     D  SDSW13In     E DS                  EXTNAME(SDSW13PD)                                  CSW213
024900200528     D                                     PREFIX(S13)                                        CSW213
025000200528                                                                                              CSW213
025100200528     D InSwift2013     DS                                                                     CSW213
025200200528     D   DLRIS1DS                          LIKE(DLRIS1In)                                     CSW213
025300200528     D   DLRIS2DS                          LIKE(DLRIS2In)                                     CSW213
025400200528     D   DLRIS3DS                          LIKE(DLRIS3In)                                     CSW213
025500200528     D   DLRIS4DS                          LIKE(DLRIS4In)                                     CSW214
025600200528      * Reporting Information                                                                 CSW213
025700200528                                                                                              CSW213
025800200528     D Trans9999_2     DS          9999                                                       CSW213
025900200528     D  SDSW13Ds                           LIKE(SDSW13In)                                     CSW213
026000200528     D  Trans2Fil8942              8942                                                       CSW213
026100200528                                                                                              CSW213
026200200528     D Trans9999_3     DS          9999                                                       CSW213
026300200528      ** +--------------------------------------+
026400200528      ** ¦ Declared Variables                   ¦
026500200528      ** ¦ ==================                   ¦
026600200528      ** +--------------------------------------+
026700200528
026800200528      ** The following /COPY line includes definitions for the above fields
026900200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
027000200528      ** corresponding fields in the PSDS /COPY member, so that member
027100200528      ** must be included where this one is used.
027200200528     D/COPY ZACPYSRC,PROCPARMS
027300200528
027400200528      ** Real message ID and message file fields for use on the calls to
027500200528      ** ZAMSGTOOPR
027600200528     D MsgID           S                   LIKE(#MsgID)
027700200528     D MsgF            S             10A
027800200528
027900200528     D******Object          S             10A   INZ('APISERVER')                            BUG10160
028000200528     D Object          S             10A   INZ('APISERVFL')                                 BUG10160
028100200528     D Lib             S             10A   INZ('*LIBL')
028200200528     D ObjType         S              7A   INZ('*DTAARA')
028300200528     D LockStateS      S              7A   INZ('*SHRRD')
028400200528     D Member          S             10A
028500200528     D WaitTime        S              6A   INZ('*CLS')
028600200528     D Dlcobj          S              1A
028700200528     D Return          S              7A
028800200528
028900200528      ** Error message for sending to the operator
029000200528     D MQError         S            132A
029100200528
029200200528      ** Other Depot Details for Securities Customer.
029300200528      ** This totals to 150 additional other depot details from the incoming message.
029400200528     D OthDData        S           4755A
029500200528
029600200528      ** Work variable used by CSW209                                                         CSW209
029700200528     D TRANS9A         S           1000A                                                      CSW209
029800200528     D TRANS9B         S           1000A                                                      CSW209
029900200528     D Trans3A         S           1000A                                                      CFT120
030000200528     D Trans5A         S           1000A                                                      CFT120
030100200528                                                                                            MD039105
030200200528     D O_BUFFER        S          32000                                                     MD039105
030300200528      ** +--------------------------------------+
030400200528      ** ¦ End of D-specs                       ¦
030500200528      ** ¦ ==============                       ¦
030600200528      ** +--------------------------------------+
030700200528
030800200528      ****************************************************************
030900200528      *                                                              *
031000200528      *  Main processing                                             *
031100200528      *                                                              *
031200200528      ****************************************************************
031300200528
031400200528      ** Loop to read all records from API Transaction file
031500200528
031600200528     C                   READ      APITRANSPD                             91
031700200528
031800200528     C     *IN91         DOWEQ     *OFF
031900200528
032000200528      ** End job if Shutdown command received
032100200528     C                   IF        TYPE = 'SHUTDOWN'
032200200528     C                   DELETE    APITRANSD0
032300200528     C                   EVAL      CTRLInfo1 = '9'
032400200528     C                   LEAVE
032500200528     C                   ENDIF
032600200528
032700200528      ** If an exception error occurred when validating the last
032800200528      ** message, then the rollback will cause the same message to
032900200528      ** be retrieved again.
033000200528      ** In this case, read the message, output to an error logging
033100200528      ** file and retrieve the next message.
033200200528      ** The module in error is stored in the return code on the
033300200528      ** APHEAD parameter.
033400200528
033500200528     C     APRETCODE     IFNE      *BLANKS
033600200528     C                   EVAL      PASSWORD = *BLANKS                                         CSD102
033700200528     C                   WRITE     APEXCPERD0
033800200528     C                   EVAL      APRETCODE = *BLANKS
033900200528      ** Perform a commit to ensure that message cannot be read again
034000200528     C                   COMMIT
034100200528     C                   ELSE
034200200528
034300200528      ** If required, validate the Profile / Password
034400200528     C                   IF        GHPWCR = 'Y'
034500200528     C                   EXSR      ValPrfPwd
034600200528     C                   ELSE                                                                 CSD102
034700200528     C                   EVAL      PASSWORD = *BLANKS                                         CSD102
034800200528     C                   EVAL      APPASSWORD = *BLANKS                                       CSD102
034900200528     C                   ENDIF
035000200528
035100200528      ** QUESI is the Error MSGID from the API call
035200200528      **   N.B. QUESI will always be blank if the checking is off
035300200528     C     QUSEI         IFEQ      *BLANKS
035400200528
035500200528     C                   EXSR      VALID8
035600200528
035700200528      ** The PrfHandle must be released to avoid hitting the job limit:
035800200528      ** 25574 simultaneous handles.
035900200528     C                   IF        GHPWCR = 'Y'
036000200528     C                   CALL      'QSYRLSPH'
036100200528     C                   PARM                    PrfHandle
036200200528     C                   ENDIF
036300200528
036400200528     C                   ELSE
036500200528
036600200528      ** Send an error message for the  Profile / Password
036700200528     C                   EXSR      PrfPwdErr
036800200528
036900200528     C                   ENDIF
037000200528
037100200528     C                   ENDIF
037200200528
037300200528     C                   DELETE    APITRANSD0
037400200528     C                   READ      APITRANSPD                             91
037500200528     C                   ENDDO
037600200528
037700200528      ** Perform a commit to ensure that the 'Shutdown' message is removed
037800200528      ** from the queue.
037900200528     C                   COMMIT
038000200528
038100200528     C                   SETON                                        LR
038200200528     C                   RETURN
038300200528      /EJECT
038400200528      ****************************************************************
038500200528      *                                                              *
038600200528      *  Validate deal type                                          *
038700200528      *                                                              *
038800200528      ****************************************************************
038900200528     C     VALID8        BEGSR
039000200528
039100200528     C                   MOVEL     BUFFER        APHEAD
039200200528
039300200528     C     APMIDUSR      IFEQ      *BLANKS
039400200528     C                   MOVEL     PSUSER        APMIDUSR
039500200528     C                   ENDIF
039600200528
039700200528      ** Log incoming data
039800200528     C                   MOVEL     *BLANKS       O_BUFFER                                    CAP186C
039900200528     C                   MOVEL     BUFFER        O_BUFFER                                    CAP186C
040000200528     C**********         WRITE     APOUTPUTD0                                               MD039105
040100200528                                                                                            MD039105
040200200528     C/exec SQL                                                                             MD039105
040300200528     C+ insert into APOUTPUTPD                                                              MD039105
040400200528     C+ (                                                                                   MD039105
040500200528     C+   BUFFER                                                                            MD039105
040600200528     C+ )                                                                                   MD039105
040700200528     C+ values                                                                              MD039105
040800200528     C+ (                                                                                   MD039105
040900200528     C+   :O_BUFFER                                                                         MD039105
041000200528     C+ )                                                                                   MD039105
041100200528     C/end-exec                                                                             MD039105
041200200528
041300200528      ** Set up the Transaction & Settlement DS's
041400200528
041500200528     C                   CALLB     'APPARSMSG'
041600200528     C                   PARM                    BUFFER
041700200528     C                   PARM                    TRANS1          500
041800200528     C                   PARM                    TRANS1A        1000                         BUG9887
041900200528     C                   PARM                    TRANS1B        1500                        BUG25877
042000200528     C                   PARM                    TRANS2          500
042100200528     C                   PARM                    TRANS3          500
042200200528     C                   PARM                    TRANS3A                                      CFT120
042300200528     C                   PARM                    TRANS4          500
042400200528     C                   PARM                    TRANS5          500
042500200528     C                   PARM                    TRANS5A                                      CFT120
042600200528     C                   PARM                    TRANS6          500
042700200528     C                   PARM                    TRANS7          500
042800200528     C                   PARM                    TRANS8          500
042900200528     C                   PARM                    TRANS9          500                          222373
043000200528     C                   PARM                    TRANS9A                                      CSW209
043100200528     C                   PARM                    TRANS9B                                      CSW209
043200200528     C                   PARM                    TRANS10         500                          262664
043300200528     C                   PARM                    PaySttmt
043400200528     C                   PARM                    RecSttmt
043500200528     C                   PARM                    FRASttmt
043600200528     C                   PARM                    PayStmtV
043700200528     C                   PARM                    RecStmtV
043800200528     C                   PARM                    PayStmtM
043900200528     C                   PARM                    RecStmtM
044000200528     C                   PARM                    InfData         500
044100200528     C                   PARM                    RegData         500                          CER001
044200200528     C                   PARM                    ExtData         500
044300200528     C                   PARM                    OthDData
044400200528     C                   PARM                    InSwift2013                                  CSW213
044500200528     C                   PARM                    Trans9999_2                                  CSW213
044600200528     C                   PARM                    Trans9999_3                                  CSW213
044700200528     C                   PARM                    Bypass            1
044800200528
044900200528      ** Any unrecognised message types are written to the error file
045000200528     C     Bypass        IFEQ      'Y'
045100200528     C                   WRITE     APEXCPERD0
045200200528     C                   COMMIT
045300200528     C                   ENDIF
045400200528
045500200528      ** Load the entire message header into the API Dump data area so that
045600200528      **  dumps in any lower level modules will include the key information
045700200528     C     *Lock         IN        APDump
045800200528     C**********         MOVEL     APHEAD        APDUMP                                       CSD102
045900200528     C                   MOVEL     APTGTTYPE     ARTGTTYPE                                    CSD102
046000200528     C                   MOVEL     APTGTSYS      ARTGTSYS                                     CSD102
046100200528     C                   MOVEL     APSRCTYPE     ARSRCTYPE                                    CSD102
046200200528     C                   MOVEL     APSRCSYS      ARSRCSYS                                     CSD102
046300200528     C                   MOVEL     APUSERID      ARUSERID                                     CSD102
046400200528     C                   MOVEL     *BLANKS       ARPASSWORD                                   CSD102
046500200528     C                   MOVEL     APFORMAT      ARFORMAT                                     CSD102
046600200528     C                   MOVEL     APVERSION     ARVERSION                                    CSD102
046700200528     C                   MOVEL     APRPYQUEUE    ARRPYQUEUE                                   CSD102
046800200528     C                   MOVEL     APRESPMODE    ARRESPMODE                                   CSD102
046900200528     C                   MOVEL     APMAPLOCN     ARMAPLOCN                                    CSD102
047000200528     C                   MOVEL     APFOTRANID    ARFOTRANID                                   CSD102
047100200528     C                   MOVEL     APFOASOCID    ARFOASOCID                                   CSD102
047200200528     C                   MOVEL     APCNFVALFO    ARCNFVALFO                                   CSD102
047300200528     C                   MOVEL     APRPRLOCN     ARRPRLOCN                                    CSD102
047400200528     C                   MOVEL     APRETCODE     ARRETCODE                                    CSD102
047500200528     C                   MOVEL     APMIDUSR      ARMIDUSR                                     CSD102
047600200528     C                   OUT       APDump
047700200528
047800200528      ** Validate
047900200528
048000200528      ** Call submodule to apply override and call appropriate
048100200528      ** validation program
048200200528     C     Bypass        IFEQ      'N'                                                        CPK015
048300200528     C                   CALLB     'APCCALLCTL'
048400200528     C                   PARM                    TYPE
048500200528     C                   PARM                    APHEAD
048600200528     C                   PARM                    TRANS1
048700200528     C                   PARM                    TRANS1A        1000                         BUG9887
048800200528     C                   PARM                    TRANS1B        1500                        BUG25877
048900200528     C                   PARM                    TRANS2
049000200528     C                   PARM                    TRANS3
049100200528     C                   PARM                    TRANS3A                                      CFT120
049200200528     C                   PARM                    TRANS4
049300200528     C                   PARM                    TRANS5
049400200528     C                   PARM                    TRANS5A                                      CFT120
049500200528     C                   PARM                    TRANS6
049600200528     C                   PARM                    TRANS7
049700200528     C                   PARM                    TRANS8
049800200528     C                   PARM                    TRANS9                                       222373
049900200528     C                   PARM                    TRANS9A                                      CSW209
050000200528     C                   PARM                    TRANS9B                                      CSW209
050100200528     C                   PARM                    TRANS10         500                          262664
050200200528     C                   PARM                    PaySttmt
050300200528     C                   PARM                    RecSttmt
050400200528     C                   PARM                    FRASttmt
050500200528     C                   PARM                    PayStmtV
050600200528     C                   PARM                    RecStmtV
050700200528     C                   PARM                    PayStmtM
050800200528     C                   PARM                    RecStmtM
050900200528     C                   PARM                    InfData
051000200528     C                   PARM                    RegData                                      CER001
051100200528     C                   PARM                    ExtData
051200200528     C                   PARM                    OthDData
051300200528     C                   PARM                    InSwift2013                                  CSW213
051400200528     C                   PARM                    Trans9999_2                                  CSW213
051500200528     C                   PARM                    Trans9999_3                                  CSW213
051600200528     C                   PARM                    #ProcPgm
051700200528     C                   PARM                    #ProcMod
051800200528     C                   PARM                    #ProcName
051900200528     C                   ENDIF                                                                CPK015
052000200528
052100200528     C                   ENDSR
052200200528      /EJECT
052300200528      ****************************************************************
052400200528      *                                                              *
052500200528      *  Validate the profile & password                             *
052600200528      *                                                              *
052700200528      ****************************************************************
052800200528     C     ValPrfPwd     BEGSR
052900200528
053000200528      ** Decode the APPASSWORD field in preparation for the validation
053100200528     C                   EXSR      DECODE
053200200528
053300200528      ** The following call is an OS/400 API which will validate
053400200528      ** the incoming message parameters of UserId and Password.
053500200528      ** If the incoming details were valid, then the field QUSEI
053600200528      ** in the Error Code structure will be blank. The profile
053700200528      ** handle must be explicitly released.
053800200528      ** If the incoming details were invalid, then the message is
053900200528      ** logged to APUNAUTHPD, and a message is sent to QSYSOPR.
054000200528      ** Unauthorised information will not be logged to APOUTPUTPD, as
054100200528      ** this file is updated during the VALID8 subroutine.
054200200528
054300200528     C                   MOVE      *BLANKS       PrfHandle
054400200528     C                   RESET                   QUSEC
054500200528
054600200528     C                   CALL      'QSYGETPH'
054700200528     C                   PARM                    USERID
054800200528     C                   PARM                    PASSWORD
054900200528     C                   PARM                    PrfHandle        12
055000200528     C                   PARM                    QUSEC
055100200528
055200200528      ** The UserID and Password fields are now irrelevant, and are
055300200528      ** starred out to prevent them appearing on log files and dumps.
055400200528     C                   MOVE      '**********'  APPASSWORD
055500200528     C                   MOVE      '**********'  PASSWORD
055600200528
055700200528     C                   ENDSR
055800200528      /EJECT
055900200528      ****************************************************************
056000200528      *                                                              *
056100200528      *  Send Profile / Password error message                       *
056200200528      *                                                              *
056300200528      ****************************************************************
056400200528     C     PrfPwdErr     BEGSR
056500200528
056600200528      ** Send message to QSYSOPR warning of attempted unauthorised
056700200528      ** access to Midas APIs
056800200528
056900200528
057000200528     C                   CLEAR                   MQError
057100200528     C                   EVAL      MsgF = 'APMSGF'
057200200528     C                   IF        APUserID = *Blanks
057300200528     C                   EVAL      MsgID = 'API0002'
057400200528     C                   ELSE
057500200528     C                   EVAL      MsgID = 'API0001'
057600200528     C                   END
057700200528
057800200528     C                   CALLB     'ZAMSGTOOPR'
057900200528     C                   PARM                    MQReturn         10
058000200528     C                   PARM                    MQError
058100200528     C                   PARM                    MsgID
058200200528     C                   PARM                    MsgF
058300200528
058400200528     C                   OPEN      APUNAUTHPD
058500200528     C                   WRITE     APUNAUTHD0
058600200528     C                   CLOSE     APUNAUTHPD
058700200528
058800200528
058900200528      ** Commit the MQGET operation
059000200528     C                   COMMIT
059100200528
059200200528     C                   ENDSR
059300200528      /EJECT
059400200528      ****************************************************************
059500200528      *                                                              *
059600200528      *  Decode the password field                                   *
059700200528      *                                                              *
059800200528      ****************************************************************
059900200528     C     DECODE        BEGSR
060000200528
060100200528     C                   MOVE      *BLANK        CURRCHAR          1
060200200528     C                   MOVE      *BLANKS       DECODED          10
060300200528     C                   Z-ADD     0             W                 1 0
060400200528     C                   Z-ADD     0             X                 3 0
060500200528     C                   Z-ADD     0             Y                 2 0
060600200528     C                   Z-ADD     1             Z                 2 0
060700200528      * W is 1 or 0 and says how blanks to pad the CAT to the decoded
060800200528      *  passwork with, depending upon whether the previous char was blank
060900200528      * X is the position in the clear or enciphered constant,
061000200528      * Y is a work field
061100200528      * Z is the position in the incoming (enciphered) password
061200200528
061300200528     C     Z             DOWLT     11
061400200528
061500200528      ** Get the next character in the password
061600200528     C     1             SUBST     PASSWORD:Z    CURRCHAR
061700200528
061800200528      ** Look up the cipher value
061900200528     C     CURRCHAR      SCAN      CIPHER        X
062000200528
062100200528      ** Ignore unrecognised characters
062200200528     C     X             IFNE      0
062300200528
062400200528     C     Z             MULT      2             Y
062500200528     C                   SUB       Y             X
062600200528     C     X             IFLE      0
062700200528     C                   ADD       63            X
062800200528     C                   ENDIF
062900200528
063000200528      ** Substitute in the correct value
063100200528     C     1             SUBST     CHARSET:X     CURRCHAR
063200200528
063300200528      ** Drop out if character is a blank
063400200528     C     CURRCHAR      IFEQ      *BLANK
063500200528     C                   LEAVE
063600200528     C                   ENDIF
063700200528     C                   ENDIF
063800200528
063900200528     C                   CAT       CURRCHAR:W    DECODED
064000200528
064100200528      ** Cater for special case of blanks
064200200528     C     CURRCHAR      IFEQ      *BLANK
064300200528     C                   Z-ADD     1             W
064400200528     C                   ELSE
064500200528     C                   Z-ADD     0             W
064600200528     C                   ENDIF
064700200528
064800200528     C                   ADD       1             Z
064900200528
065000200528     C                   ENDDO
065100200528
065200200528     C                   MOVEL     DECODED       PASSWORD
065300200528     C                   ENDSR
065400200528      /EJECT
065500200528      ****************************************************************
065600200528      *                                                              *
065700200528      *  Initialisation                                              *
065800200528      *                                                              *
065900200528      ****************************************************************
066000200528     C     *INZSR        BEGSR
066100200528
066200200528     C     *ENTRY        PLIST
066300200528     C                   PARM                    JournalEnt
066400200528     C                   PARM                    ControlInf
066500200528
066600200528      * If the first byte of Control Information is 0, no data has been
066700200528      *  passed so simply return
066800200528
066900200528     C                   IF        CTRLInfo1 = '0'
067000200528     C                   SETON                                        LR                      248330
067100200528     C                   RETURN
067200200528     C                   ENDIF
067300200528
067400200528      *  Lock allocation data area
067500200528
067600200528      *   The data area is allocated *SHRRD here.
067700200528      *   The function to submit this tries to get a *EXCL lock.
067800200528
067900200528      *                         Submitter
068000200528      *                 Lock      Lock     Submitter
068100200528      *      Status    Status   Successful   Action
068200200528      *      ------    ------   ---------- ---------
068300200528      *   Not running  None        Yes      Submit this
068400200528
068500200528      *   Running      *SHRRD      No        None
068600200528
068700200528     C                   CALLB     'APCALCOBJ'
068800200528     C                   PARM                    Object
068900200528     C                   PARM                    Lib
069000200528     C                   PARM                    ObjType
069100200528     C                   PARM                    LockStateS
069200200528     C                   PARM                    Member
069300200528     C                   PARM                    WaitTime
069400200528     C                   PARM                    Dlcobj
069500200528     C                   PARM                    Return
069600200528
069700200528      ** Set up Midas SPF Environment
069800200528     C                   CALL      'SFC0401'
069900200528
070000200528      ** Create required QTEMP objects
070100200528     C                   CALL      'APCCRTQTO'
070200200528     C                   PARM                    ReturnCde        10
070300200528
070400200528      ** Check for success, else bomb
070500200528     C     ReturnCde     IFNE      *BLANKS
070600200528     C                   ENDIF
070700200528
070800200528      ** Log job start-up in jobs file
070900200528     C                   OPEN      APIJOBL0
071000200528     C                   WRITE     JOBRCD
071100200528     C                   CLOSE     APIJOBL0
071200200528
071300200528      ** Set up the procedure/module/program names for calls to the
071400200528      **  validation modules
071500200528     C                   EVAL      #ProcPgm  = PSProcPgm
071600200528     C                   EVAL      #ProcMod  = PSProcMod
071700200528     C                   EVAL      #ProcName = PSProcName
071800200528
071900200528      ** Call CL to start commitment control
072000200528     C                   CALLB     'ZACSCMTCTL'
072100200528
072200200528      ** Access API ICD via access program
072300200528      *  (database error handling done in access program)
072400200528     C                   CALLB     'AOAPIR0'
072500200528     C                   PARM      '*DBERR '     @RTCD             7
072600200528     C                   PARM      '*FIRST '     @OPTN             7
072700200528     C     SDAPI         PARM      SDAPI         DSFDY
072800200528
072900200528      ***Ensure*that*all*the*API*data*queues*exist*                                           CPK030
073000200528     C**********         CLEAR                   ReturnCode                                   CPK030
073100200528     C**********         CALL      'APCRTDTAQS'                                               CPK030
073200200528     C**********         PARM                    ReturnCode                                   CPK030
073300200528
073400200528      ** Create dtaara ZBRU in QTEMP                                                          248812
073500200528     C                   MOVE      *BLANKS       CMDTXT                                       248812
073600200528     C                   MOVEA     CRT@(1)       CMDTXT                                       248812
073700200528     C                   CALL      'QCMDEXC'                            9999                  248812
073800200528     C                   PARM                    CMDTXT           50                          248812
073900200528     C                   PARM      50            LEN              15 5                        248812
074000200528
074100200528      ** Create dtaara ZOBU in QTEMP                                                          248812
074200200528     C                   MOVE      *BLANKS       CMDTXT                                       248812
074300200528     C                   MOVEA     CRT@(2)       CMDTXT                                       248812
074400200528     C                   CALL      'QCMDEXC'                            9999                  248812
074500200528     C                   PARM                    CMDTXT                                       248812
074600200528     C                   PARM      50            LEN                                          248812
074700200528
074800200528      ***Create*dtaara*ZVRU1*in*QTEMP**                                               248812 248812A
074900200528      ** Create dtaara ZBRU1 in QTEMP                                                        248812A
075000200528      ** Increase command text length                                                        248812B
075100200528     C**********         MOVE      *BLANKS       CMDTXT                               248812 248812B
075200200528     C**********         MOVEA     CRT@(3)       CMDTXT                               248812 248812B
075300200528     C                   MOVE      *BLANKS       CMDTXT2                                     248812B
075400200528     C                   MOVEA     CRT@(3)       CMDTXT2                                     248812B
075500200528     C                   CALL      'QCMDEXC'                            9999                  248812
075600200528     C**********         PARM                    CMDTXT                               248812 248812B
075700200528     C**********         PARM      50            LEN                                  248812 248812B
075800200528     C                   PARM                    CMDTXT2          80                         248812B
075900200528     C                   PARM      80            LEN                                         248812B
076000200528
076100200528      ** Create dtaara ZBRU2 in QTEMP                                                        248812B
076200200528     C                   MOVE      *BLANKS       CMDTXT                                      248812B
076300200528     C                   MOVEA     CRT@(4)       CMDTXT                                      248812B
076400200528     C                   CALL      'QCMDEXC'                            9999                 248812B
076500200528     C                   PARM                    CMDTXT                                      248812B
076600200528     C                   PARM      50            LEN                                         248812B
076700200528                                                                                             248812B
076800200528      ** Create dtaara ZOBU1 in QTEMP                                                        248812B
076900200528     C                   MOVE      *BLANKS       CMDTXT2                                     248812B
077000200528     C                   MOVEA     CRT@(5)       CMDTXT2                                     248812B
077100200528     C                   CALL      'QCMDEXC'                            9999                 248812B
077200200528     C                   PARM                    CMDTXT2                                     248812B
077300200528     C                   PARM      80            LEN                                         248812B
077400200528                                                                                             248812B
077500200528      ** Create dtaara ZOBU2 in QTEMP                                                        248812B
077600200528     C                   MOVE      *BLANKS       CMDTXT                                      248812B
077700200528     C                   MOVEA     CRT@(6)       CMDTXT                                      248812B
077800200528     C                   CALL      'QCMDEXC'                            9999                 248812B
077900200528     C                   PARM                    CMDTXT                                      248812B
078000200528     C                   PARM      50            LEN                                         248812B
078100200528                                                                                             248812B
078200200528     C                   ENDSR
078300200528      /EJECT
078400200528      ****************************************************************
078500200528      **------------------------------------------------------------------------
078600200528      ** The following /COPY contains the standard program status
078700200528      ** subroutine, including a bound call to the DBERRCTL module.
078800200528     C/COPY ZACPYSRC,PSSR_ILE
078900200528      **------------------------------------------------------------------------
079000200528      ****************************************************************
079100200528      /EJECT
079200200528      ****************************************************************
079300200528**  CPY@
079400200528(c) Finastra International Limited 2003
079500200528**  CRT@                                                                                      248812
079600200528CRTDTAARA DTAARA(QTEMP/ZBRU) TYPE(*CHAR) LEN(304)                                             248812
079700200528CRTDTAARA DTAARA(QTEMP/ZOBU) TYPE(*CHAR) LEN(304)                                             248812
079800200528CRTDTAARA DTAARA(QTEMP/ZBRU1) TYPE(*CHAR) LEN(1998)                                   248812 248812A
079900200528CRTDTAARA DTAARA(QTEMP/ZBRU2) TYPE(*CHAR) LEN(402)                                           248812B
080000200528CRTDTAARA DTAARA(QTEMP/ZOBU1) TYPE(*CHAR) LEN(1998)                                          248812B
080100200528CRTDTAARA DTAARA(QTEMP/ZOBU2) TYPE(*CHAR) LEN(402)                                           248812B
