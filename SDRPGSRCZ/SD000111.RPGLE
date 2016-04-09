     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Standard Default Reporting Information')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000111 - Standard Default Reporting Information            *
      *             Maintenance                                       *
      *                                                               *
      *  Function: This program maintains the definition of the       *
      *            Reporting Information which will be used for       *
      *            defaulting Reporting Information process during    *
      *            FX and FRA/IRS transaction input.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD030328           Date 25Nov14               *
      *  Prev Amend No. MD027482           Date 25Nov14               *
      *                 MD028258           Date 25Nov14               *
      *                 MD028088           Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 MD023614A          Date 25Nov13               *
      *                 MD023614           Date 20Nov13               *
      *                 MD022288           Date 16Sep13               *
      *                 MD021931           Date 27Aug13               *
      *                 MD022158           Date 30Aug13               *
      *                 MD021923           Date 23Aug13               *
      *                 MD021883           Date 22Aug13               *
      *                 MD021546           Date 08Aug13               *
      *                 MD021633           Date 07Aug13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD030328 - In Reporting Information default maintenance,     *
      *             Counterparty number and currency field are not    *
      *             functioning during filter/enquire mode            *
      *           - Counterparty number filter is not cleared on F5   *
      *  MD027482 - Reporting Party Id field accepts special          *
      *             characters without error                          *
      *  MD028258 - Error message displayed twice for A and D action  *
      *             code against deleted records                      *
      *  MD028088 - If transaction type in SDRI is blank, Clearing    *
      *             Broker is not displayed.                          *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD023614 - No highlight and error message generated for      *
      *             invalid input in line 9 of Additional Reporting   *
      *             (Reopen)                                          *
      *  MD023614 - No highlight and error message generated for      *
      *             invalid input in line 9 of Additional Reporting   *
      *             Information                                       *
      *  MD022288 - Repository ID should be optional                  *
      *  MD021931 - Incorrect error messages in Additional Reporting  *
      *             Information fields.                               *
      *  MD022158 - Reporting Party ID is being defaulted             *
      *  MD021923 - Warning message is not being displayed when       *
      *             Reporting Jurisdiction is 'OTHR' and Additional   *
      *             Reporting Information is not entered.             *
      *  MD021883 - Incomplete/incorrect error description on various *
      *             fields                                            *
      *  MD021546 - CL is not accepted in Transaction Type field      *
      *  MD021633 - Unable to filter records using counterparty       *
      *             number or currency                                *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    09         F9 Add/Change Mode                              *
      *    12         F12 Previous                                    *
      *    23         F23 Confirm Delete                              *
      *    27         Rollup/Rolldown Key                             *
      *    40         Global Error Indicator                          *
      *    61         WRITE Indicator                                 *
      *    62         READC Indicator                                 *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Subfile End (SFLEND)                            *
      *    83         Force Input Format                              *
      *    87         Enable Key Screen                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRBuild       -  Initialise and load subfile page            *
      *  SRLoad        -  Load subfile page                           *
      *  SRDisplay     -  Display subfile                             *
      *  SRProcess     -  Process screen input                        *
      *  SREnquire     -  Process enquire, display detail screen 1    *
      *  SREnqScr2     -  Process enquire, display detail screen 2    *
      *  SREnqScr3     -  Process enquire, display detail screen 3    *                       CSW214
      *  SRAdd         -  Process add                                 *
      *  SRKeyScrnV    -  Validate key screen input                   *
      *  SRAmend       -  Process amend                               *
      *  SRDelete      -  Process delete, display detail screen 1     *
      *  SRDelScr2     -  Process delete, display detail screen 2     *
      *  SRScrn2       -  Process detail screen 1 input               *
      *  SRScrn2Clr    -  Initialise detail screen 1                  *
      *  SRScrn2v      -  Validate detail screen 1 input              *
      *  SRScrn3       -  Process detail screen 2 input               *
      *  SRScrn3Clr    -  Initialise detail screen 2                  *
      *  SRScrn3v      -  Validate detail screen 2 input              *
      *  SRScrn4       -  Process detail screen 3 input               *                       CSW214
      *  SRScrn4Clr    -  Initialise detail screen 3                  *                       CSW214
      *  SRScrn4v      -  Validate detail screen 3 input              *                       CSW214
      *  SRReload      -  Request subfile reload                      *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Transfer records from SDRPIFL0 to subfile   *
      *  SRWrite       -  Insert/Amend/Delete record from file        *
      *  SRDelete      -  Delete Country of Tax Details               *
      *  SRAmend       -  Update Country of Tax Details               *
      *  SRZasnms      -  Message handling subroutine 1               *
      *  SRZasnms2     -  Message handling subroutine 2               *
      *  SRGetScrn2    -  Retrieve detail screen 1 details            *
      *  SRGetScrn3    -  Retrieve detail screen 2 details            *
      *  SRMovetoFile  -  Move fields from screen to file             *
      *  SRGetCusDtl   -  Retrieve customer details                   *
      *  SRChkXSet     -  Check for valid SWIFT characters (X-set)    *
      *  SRCodeWord    -  Check for valid codewords                   *
      *  SRChkActn     -  Check for allowed action codes for user     *
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSD000111DFCF   E             WORKSTN
     F                                     SFILE(SD000111S1:SRLRN)
     F                                     INFSR(*PSSR)
 
      ** Standard Reporting Information Update Index
     FSDRPIFL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDRPIFD0:RPIFL1)
 
      ** Standard Reporting Information Retrieval Index
     FSDRPIFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDRPIFD0:RPIFL0)
 
      ** Customer Extension SWIFT Details Retrieve Index
     FSDCSSWL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Deal type/sub-type file
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
 
     ** Additional Information array
     D AddlRepiDS      DS
     D***S4AD01                                                                               CSW214
     D***S4AD02                                                                               CSW214
     D***S4AD03                                                                               CSW214
     D***S4AD04                                                                               CSW214
     D***S4AD05                                                                               CSW214
     D***S4AD06                                                                               CSW214
     D***S4AD07                                                                               CSW214
     D***S4AD08                                                                               CSW214
     D***S4AD09                                                                               CSW214
     D***S4AD10                                                                               CSW214
     D***S4AD11                                                                               CSW214
     D***S4AD12                                                                               CSW214
     D***S4AD13                                                                               CSW214
     D***S4AD14                                                                               CSW214
     D***S4AD15                                                                               CSW214
     D***S4AD16                                                                               CSW214
     D***S4AD17                                                                               CSW214
     D***S4AD18                                                                               CSW214
     D***S4AD19                                                                               CSW214
     D***S4AD20                                                                               CSW214
     D  S7AD01                                                                                CSW214
     D  S7AD02                                                                                CSW214
     D  S7AD03                                                                                CSW214
     D  S7AD04                                                                                CSW214
     D  S7AD05                                                                                CSW214
     D  S7AD06                                                                                CSW214
     D  S7AD07                                                                                CSW214
     D  S7AD08                                                                                CSW214
     D  S7AD09                                                                                CSW214
     D  S7AD10                                                                                CSW214
     D  S7AD11                                                                                CSW214
     D  S7AD12                                                                                CSW214
     D  S7AD13                                                                                CSW214
     D  S7AD14                                                                                CSW214
     D  S7AD15                                                                                CSW214
     D  S7AD16                                                                                CSW214
     D  S7AD17                                                                                CSW214
     D  S7AD18                                                                                CSW214
     D  S7AD19                                                                                CSW214
     D  S7AD20                                                                                CSW214
 
      ** Action Code Array
     D ActnCdAr        S              1    DIM(6)
 
      ** FX deal type array
     D***FXDLAr*         S              2A   DIM(9) CTDATA PERRCD(1)                        MD021546
     D***FXDLDes         S             30A   DIM(9) ALT(FXDLAr)                             MD021546
     D FXDLAr          S              2A   DIM(10) CTDATA PERRCD(1)                         MD021546
     D FXDLDes         S             30A   DIM(10) ALT(FXDLAr)                              MD021546
 
      ** FRA/IRS deal type array
     D FRAIRSAr        S              2A   DIM(6) CTDATA PERRCD(1)
     D FRAIRSDes       S             30A   DIM(6) ALT(FRAIRSAr)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Account Code Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for Branch Code Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D BQQDFAC       E                     EXTFLD(QQDFAC)
 
      ** External data structure for Currency Code Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for Deal Type/Sub-type Details
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
 
      ** External data structure for Midas Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External data structure for Customer Extension SWIFT Details
     D SDCSSW        E DS                  EXTNAME(SDCSSWPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Function keys
     D CAIN12          S              1
     D CAIN10          S              1
     D CAIN12A         S              1                                                       CSW214
 
      ** Error work fields
     D PRTCD           S              7
     D POPTN           S              7
     D PCNCD           S              2
     D PACOD           S              4
     D PCUST           S             10
     D PKYST           S              7
 
      ** Message file workfields
     D PZMsgFile       S             10A
     D PZMsgID         S             10
     D PZMsgData       S             45
 
      ** General workfields
     D PMODE           S              1
     D WLRCD           S              4  0
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D W1RSF           S              1
     D W1RKY           S              1
     D W1RD1           S              1
     D W1RD3           S              1                                                       CSW214
     D WSCR3           S              1    INZ('N')                                           CSW214
     D W#EROR          S              1
     D W#EROR2         S              1
     D W#EROR3         S              1
     D W#EROR4         S              1                                                       CSW214
     D W#WARN          S              1
     D W#AMT           S              1
     D WARN            S              1  0
     D WriteErr        S              1
     D CodeWordOK      S              1
     D CWordChk        S             35
     D CWordFld        S              8
     D CharPos         S              1  0
     D CtpyNonSWIFT    S             10
     D CtpySWIFT       S             10
     D CurrencyOK      S              1
     D EmbdBlanks      S              1
     D SWIFTChar       S              1
     D SlashChk        S              2
     D SlashOK         S              1
     D W1TMST          S               Z
     D TimeStamp       S               Z
     D WSlash          S              1
     D WSlash2         S              2  0
     D FldChk          S             50
     D Line1           S              1
     D PEXVE           S             35
     D PEXVEOk         S              1
     D WSEL            S              1
     D WSelFld         S              1
     D WStr            S              5  0
     D WLen            S              5  0
     D***X******       S              1  0                                                  MD021546
     D X               S              2  0                                                  MD021546
     D***Y******       S              1  0                                                  MD021546
     D Y               S              2  0                                                  MD021546
     D Z               S              2  0
     D ERCD            S              1  0
     D AMNT            S             15  0
     D BNDCSP          S              1
     D ZField          S             16
     D ZDecimal        S              1  0
     D ZAction         S              6
     D ZError          S              1  0
     D W4CTAM          S             15
     D CodeWordCnt     S              2  0                                                 MD023614A
     D SlashCnt        S              2  0                                                 MD023614A
     D CSW214          S              1                                                       CSW214
 
      ** Subfile workfields
     D WSkipRec        S              1
 
      ** REPIKY key fields
     D K1BRCH          S              3
     D K1TYPE          S              2
     D K1STPE          S              2
     D K1CUSN          S              6
     D K1CURR          S              3
     D K1PMLI          S              1
 
      ** QCLSCAN parameters
     D QLength1        S              3  0
     D QStart          S              3  0
     D QLength2        S              3  0
     D QTranslate      S              1
     D QTrim           S              1
     D QWild           S              1
     D QResult         S              3  0
 
      ** System Values
     D SVAL1           S             20A   INZ('DLSWIFTCtpyNonSWIFT')
     D SVAL2           S             20A   INZ('DLSWIFTCtpySWIFT')
 
      ** Valid SWIFT/Telex characters
     D ISO             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                      abcdefghijklmnopqrstuvwxyz-
     D                                      1234567890 /+-?:().,'''
 
      ** Valid Alphabetic Characters
     D Alpha           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Main Program
 
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page
 
     C                   EXSR      SRBuild
 
     C                   EVAL      W1RSF = 'N'
     C                   EVAL      WSCR3 = 'N'                                                CSW214
 
      ** Display screen until reload requested
 
     C                   DOW       W1RSF = 'N'
 
      ** Display screen
 
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *IN03         CASEQ     *ON           SREnd
     C     *IN05         CASEQ     *ON           SRReload
     C     *IN27         CASEQ     *ON           SRLoad
     C                   CAS                     SRProcess
     C                   ENDCS
 
     C                   IF        *IN03 = *ON
     C                   EXSR      SREnd
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDDO
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      *****************************************************************
     C     SRBuild       BEGSR
 
      ** Clear messages from program message queue                                          MD021923
                                                                                            MD021923
     C                   CALL      'ZA0250'                                                 MD021923
                                                                                            MD021923
      ** Initialise & load subfile page
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000111C1
     C                   EVAL      *IN80 = *OFF
 
      ** Reset Number of Records in Subfile
 
     C                   Z-ADD     0             WLRCD
 
     C     *LOVAL        SETLL     SDRPIFL0
     C                   READ      SDRPIFL0                               82
 
      ** Save previous selector values
 
     C     *LIKE         DEFINE    SEBRCH        WZBRCH
     C                   EVAL      WZBRCH = SEBRCH
     C     *LIKE         DEFINE    SETYPE        WZTYPE
     C                   EVAL      WZTYPE = SETYPE
     C     *LIKE         DEFINE    SESTPE        WZSTPE
     C                   EVAL      WZSTPE = SESTPE
     C     *LIKE         DEFINE    SECUSN        WZCUSN
     C                   EVAL      WZCUSN = SECUSN
     C     *LIKE         DEFINE    SECURR        WZCURR
     C                   EVAL      WZCURR = SECURR
     C     *LIKE         DEFINE    SEPMLI        WZPMLI
     C                   EVAL      WZPMLI = SEPMLI
 
      ** Load subfile page
 
     C                   EXSR      SRLoad
 
      ** If no records found, display error message
 
     C                   IF        *IN82 = *ON AND SRLRN = 0
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      *****************************************************************
     C     SRLoad        BEGSR
 
     C                   EVAL      *IN73 = *OFF
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     WLRCD         SRLRN
     C                   Z-ADD     1             WRCTR
 
      ** Load next subfile page
 
     C                   DOW       *IN82 = '0' and WRCTR <= WSFPG
 
     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             SRLRN
 
     C                   IF        SEBRCH <> *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    RPBRCH
     C                   PARM      3             QLength1
     C                   PARM      1             QStart
     C                   PARM                    SEBRCH
     C                   PARM      3             QLength2
     C                   PARM      '1'           QTranslate
     C                   PARM      '1'           QTrim
     C                   PARM      '?'           QWild
     C                   PARM                    QResult
     C                   IF        QResult < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SETYPE <> *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    RPTYPE
     C                   PARM      2             QLength1
     C                   PARM      1             QStart
     C                   PARM                    SETYPE
     C                   PARM      2             QLength2
     C                   PARM      '1'           QTranslate
     C                   PARM      '1'           QTrim
     C                   PARM      '?'           QWild
     C                   PARM                    QResult
     C                   IF        QResult < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SESTPE <> *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    RPSTPE
     C                   PARM      2             QLength1
     C                   PARM      1             QStart
     C                   PARM                    SESTPE
     C                   PARM      2             QLength2
     C                   PARM      '1'           QTranslate
     C                   PARM      '1'           QTrim
     C                   PARM      '?'           QWild
     C                   PARM                    QResult
     C                   IF        QResult < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SECUSN <> *BLANKS
     C                   CALL      'QCLSCAN'
     C**********         PARM                    RPSTPE                                     MD021633
     C                   PARM                    RPCUSN                                     MD021633
     C                   PARM      6             QLength1
     C                   PARM      1             QStart
     C                   PARM                    SECUSN
     C                   PARM      6             QLength2
     C                   PARM      '1'           QTranslate
     C                   PARM      '1'           QTrim
     C                   PARM      '?'           QWild
     C                   PARM                    QResult
     C                   IF        QResult < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SECURR <> *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    RPCURR
     C                   PARM      3             QLength1
     C                   PARM      1             QStart
     C**********         PARM                    SECUSN                                     MD021633
     C                   PARM                    SECURR                                     MD021633
     C                   PARM      3             QLength2
     C                   PARM      '1'           QTranslate
     C                   PARM      '1'           QTrim
     C                   PARM      '?'           QWild
     C                   PARM                    QResult
     C                   IF        QResult < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SEPMLI <> *BLANKS
     C                   IF        SEPMLI <> RPPMLI
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WSkipRec = 'N'
 
      ** Clear subfile fields
 
     C                   EXSR      SRClrScrn
 
      ** Load subfile fields
 
     C                   EXSR      SRMove
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR                81
 
     C                   WRITE     SD000111S1
 
     C                   ELSE
     C                   SUB       1             SRLRN
     C                   ENDIF
 
      ** End of File
 
     C                   READ      SDRPIFL0                               82
     C                   ENDDO
 
     C                   Z-ADD     SRLRN         WLRCD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
      ** Display appropriate header depending upon Mode
 
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN84 = *ON
     C                   ENDIF
 
      ** Check for authorised action codes for user/program
 
     C                   EXSR      SrChkActn
 
     C                   WRITE     SD000111F5
     C                   WRITE     SD000111C0
 
     C                   IF        WLRCD = 0
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000111C1
     C                   EVAL      *IN80 = *OFF
     C                   Z-ADD     1             SRLRN
     C                   EVAL      *IN71 = *ON
     C                   WRITE     SD000111S1
     C                   EVAL      *IN71 = *OFF
     C                   WRITE     SD000111C1
     C                   READ      SD000111C1
     C                   ELSE
     C                   EXFMT     SD000111C1
     C                   ENDIF
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process Request                                   *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
 
     C     REPIKY        KLIST
     C                   KFLD                    K1BRCH
     C                   KFLD                    K1TYPE
     C                   KFLD                    K1STPE
     C                   KFLD                    K1CUSN
     C                   KFLD                    K1CURR
     C                   KFLD                    K1PMLI
 
     C                   EVAL      S1RECI = *BLANKS
     C                   EVAL      S1BRCH = *BLANKS
     C                   EVAL      S1TYPE = *BLANKS
     C                   EVAL      S1STPE = *BLANKS
     C                   EVAL      S1CURR = *BLANKS
     C                   EVAL      S1CUSN = *BLANKS
     C                   EVAL      S1PMLI = *BLANKS
     C                   EVAL      S1RPNM = *BLANKS
     C                   EVAL      S1RPTN = *BLANKS
 
      ** Process Enquire/Amend/Delete
 
     C                   IF        *IN09 <> *ON
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF
     C                             and W1RSF = 'N' and WLRCD <> *ZEROS
 
     C                   EVAL      ActnCnt = 0
     C                   READC     SD000111S1                             62
 
     C                   DOW       *IN62 = *OFF
 
     C                   EVAL      *IN73 = *OFF
     C                   EVAL      ActnErr = *BLANKS
 
      ** Invalid Action Code
 
     C                   IF        S1ACTN <> 'E' AND
     C                             S1ACTN <> 'D' AND
     C                             S1ACTN <> 'A' AND
     C                             S1ACTN <> *BLANKS
     C                             OR S1ACTN <> 'E' AND
     C                                S1ACTN <> ' ' AND
     C                                PMODE = 'E'
     C                   MOVE      'Y'           ActnErr           1
     C                   EVAL      *IN73 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PZMsgID = 'USR8803'
     C                   IF        PMODE = 'E'
     C                   EVAL      PZMsgID = 'USR7710'
     C                   ENDIF
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** User can only enquire a deleted record
 
     C                   IF        (S1ACTN = 'A' OR S1ACTN = 'D') AND
     C                             S1RECI = '*'
     C                   MOVE      'Y'           ActnErr           1
     C                   EVAL      *IN73 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PZMsgID = 'USR8703'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** User not authorised to action code
 
     C                   IF        S1ACTN = 'A' AND *IN16 = *OFF
     C                             OR S1ACTN = 'D' AND *IN17 = *OFF
     C                             OR S1ACTN = 'E' AND *IN18 = *OFF
     C                   MOVE      'Y'           ActnErr           1
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PZMsgID = 'USR0726'
     C                   EXSR      SRZAsnms
     C                   ENDIF
 
      ** Process Enquire
 
     C                   IF        S1ACTN = 'E'
     C                   EXSR      SREnquire
     C                   ENDIF
 
      ** Process Delete
 
     C                   IF        S1ACTN = 'D' AND PMODE = 'M'
     C                   EXSR      SRDelete
     C                   ENDIF
 
      ** Process Amend
 
     C                   IF        S1ACTN = 'A' AND PMODE = 'M'
     C                   EXSR      SRAmend
     C                   ENDIF
 
     C                   IF        *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   IF        ActnErr = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   UPDATE    SD000111S1
     C                   EVAL      *IN31 = *OFF
     C                   ADD       1             ActnCnt           2 0
     C                   LEAVE                                                              MD028258
     C                   ELSE
     C                   EVAL      S1ACTN = *BLANKS
     C                   EVAL      *IN31 = *OFF
     C                   UPDATE    SD000111S1
     C                   ENDIF
     C                   READC     SD000111S1                             62
 
     C                   ENDDO
     C                   EVAL      W1RSF = 'Y'
 
     C                   ENDDO
 
     C                   IF        ActnCnt > 0
     C                   EVAL      W1RSF = 'N'
     C                   ELSE
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        *IN09 = *ON AND PMODE = 'M'
 
      ** User not authorised to action code
 
     C                   IF        *IN19 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'USR0726'
     C                   EXSR      SRZasnms
     C                   GOTO      SRProcessE
     C                   ENDIF
 
      ** Process Add
 
     C                   EXSR      SRAdd
 
     C                   IF        W#EROR3 = *BLANKS AND
     C                             *IN03 = *OFF AND
     C                             *IN10 = *OFF
     C                   EXSR      SRReload
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     SRProcessE    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnquire - Process Enquire                                   *
      *                                                               *
      *****************************************************************
     C     SREnquire     BEGSR
 
     C                   EVAL      K1BRCH = S1BRCH
     C                   EVAL      K1TYPE = S1TYPE
     C                   EVAL      K1STPE = S1STPE
     C                   EVAL      K1CUSN = S1CUSN
     C                   EVAL      K1CURR = S1CURR
     C                   EVAL      K1PMLI = S1PMLI
 
     C     REPIKY        CHAIN     SDRPIFL0
     C                   IF        NOT %FOUND
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   GOTO      SREnquireE
     C                   ENDIF
 
     C                   EXSR      SRScrn2Clr
     C                   EXSR      SrGetScrn2
 
     C                   EVAL      W1RSF = 'N'
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN70 = *OFF
     C**********         MOVEA     '0000000000'  *IN(47)                                      CSW214
     C                   MOVEA     '0000000'     *IN(47)                                      CSW214
     C                   MOVEA     '00'          *IN(96)                                      CSW214
 
     C                   EVAL      *IN11 = *OFF
     C                   IF        *IN14 = *ON
     C                   EVAL      *IN11 = *ON
     C                   ENDIF
 
     C                   DOW       *IN03 = *OFF AND
     C                             *IN12 = *OFF AND
     C                             W1RSF = 'N'
     C                             OR CAIN12 = *ON
 
     C                   EVAL      CAIN12 = *OFF
     C                   WRITE     SD000111C0
     C                   WRITE     SD000111F6
     C                   EXFMT     SD000111F3
 
      ** If Enter key is pressed, go to detail screen 2
 
     C                   IF        *IN03 = *OFF AND
     C                             *IN10 = *OFF
     C                   EXSR      SrEnqScr2
     C                   ENDIF
     C                   ENDDO
 
     C     SrEnquireE    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnqSrc2 - Display Enquire Detail Screen 2                   *
      *                                                               *
      *****************************************************************
     C     SREnqScr2     BEGSR
 
     C                   EXSR      SRScrn3Clr
     C                   EXSR      SRGetScrn3
 
     C                   EVAL      W1RD1 = 'N'
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN70 = *OFF
 
     C                   MOVEA     '0000000000'  *IN(57)
     C**********         MOVEA     '000'         *IN(67)                                      CSW214
     C**********         MOVEA     '00000'       *IN(74)                                      CSW214
     C**********         MOVEA     '000'         *IN(22)                                      CSW214
     C**********         MOVEA     '00000'       *IN(26)                                      CSW214
     C**********         MOVEA     '00000'       *IN(33)                                      CSW214
     C                   MOVEA     '00000000'    *IN(88)                                      CSW214
     C                   MOVEL     '0'           *IN67                                        CSW214
     C                   MOVEA     '000'         *IN(54)                                      CSW214
 
     C                   DOW       *IN03 = *OFF AND
     C                             *IN12 = *OFF AND
     C                             W1RD1 = 'N'
     C                             OR CAIN12A = *ON                                           CSW214
 
     C                   EVAL      CAIN12A = *OFF                                             CSW214
     C                   WRITE     SD000111C0
     C                   WRITE     SD000111F6
     C                   EXFMT     SD000111F4
 
      ***If*Enter*key*is*pressed,*go*back*to*main*screen                                      CSW214
      ** If Enter key is pressed, go to detail screen 3                                       CSW214
 
     C                   IF        *IN03 = *OFF AND *IN12 = *OFF
     C**********         EVAL      W1RD1 = 'Y'                                                CSW214
     C**********         EVAL      W1RSF = 'Y'                                                CSW214
     C                   EXSR      SrEnqScr3                                                  CSW214
     C                   ENDIF
      ** Reset CAIN12 to *OFF, if F3 was pressed                                              CSW214
     C                   IF        *IN03 = *ON                                                CSW214
     C                   EVAL      CAIN12 = *OFF                                              CSW214
     C                   ENDIF                                                                CSW214
 
      ** If F12 is pressed, go back to detail screen 1
 
     C                   IF        *IN12 = *ON
     C                   EVAL      CAIN12 = *IN12
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW214
      *                                                               *                       CSW214
      * SREnqScr3 - Display Enquire Detail Screen 3                   *                       CSW214
      *                                                               *                       CSW214
      *****************************************************************                       CSW214
     C     SREnqScr3     BEGSR                                                                CSW214
     C                   EXSR      SRScrn4Clr                                                 CSW214
     C                   EXSR      SRGetScrn4                                                 CSW214
     C                   EVAL      W1RD1 = 'N'                                                CSW214
     C                   MOVEA     '00'          *IN(68)                                      CSW214
     C                   MOVEA     '00000'       *IN(74)                                      CSW214
     C                   MOVEA     '000'         *IN(22)                                      CSW214
     C                   MOVEA     '00000'       *IN(26)                                      CSW214
     C                   MOVEA     '00000'       *IN(33)                                      CSW214
     C                   DOW       *IN03 = *OFF AND                                           CSW214
     C                             *IN12 = *OFF AND                                           CSW214
     C                             W1RD1 = 'N'                                                CSW214
                                                                                              CSW214
     C                   WRITE     SD000111C0                                                 CSW214
     C                   WRITE     SD000111F6                                                 CSW214
     C                   EXFMT     SD000111F7                                                 CSW214
                                                                                              CSW214
      ** If Enter key is pressed, go back to main screen                                      CSW214
                                                                                              CSW214
     C                   IF        *IN03 = *OFF AND *IN12 = *OFF                              CSW214
     C                   EVAL      W1RD1 = 'Y'                                                CSW214
     C                   EVAL      W1RSF = 'Y'                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** If F12 is pressed, go back to detail screen 2                                        CSW214
                                                                                              CSW214
     C                   IF        *IN12 = *ON                                                CSW214
     C                   EVAL      CAIN12A = *IN12                                            CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDDO                                                                CSW214
     C                   ENDSR                                                                CSW214
      *****************************************************************                       CSW214
      /EJECT                                                                                  CSW214
      *****************************************************************
      *                                                               *
      * SRAdd - Process Add                                           *
      *                                                               *
      *****************************************************************
     C     SRAdd         BEGSR
 
     C                   EVAL      S2BRCH = *BLANKS
     C                   EVAL      S2TYPE = *BLANKS
     C                   EVAL      S2STPE = *BLANKS
     C                   EVAL      S2CUSN = *BLANKS
     C                   EVAL      S2CURR = *BLANKS
     C                   EVAL      S2PMLI = *BLANKS
 
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN70 = *OFF
 
     C                   DOW       *IN03 = *OFF AND *IN12 = *OFF AND
     C                             W1RSF = 'N' OR CAIN12 = *ON
     C                             OR WSEL = 'Y'
     C
     C                   EVAL      CAIN12 = *OFF
     C                   EVAL      WSelFld = *BLANKS
     C                   EVAL      WSEL = *BLANKS
 
     C                   WRITE     SD000111C0
     C                   WRITE     SD000111F6
     C                   EXFMT     SD000111F2
 
      ** Clear messages from program message queue
      ** and reset work fields
 
     C                   CALL      'ZA0250'
     C                   EVAL      W#EROR = *BLANKS
     C                   MOVEA     '0000000'     *IN(40)
 
      ** If exit not pressed, validate key fields screen first
      ** before displaying the second input screen
 
     C                   IF        *IN03 = *OFF and *IN12 = *OFF
 
     C                   EVAL       S3BRCH = *BLANKS
     C                   EVAL       S3BRDS = *BLANKS
     C                   EVAL       S3TYDS = *BLANKS
     C                   EVAL       S3STDS = *BLANKS
     C                   EVAL       S3CUSN = *BLANKS
     C                   EVAL       S3RPNM = *BLANKS
     C                   EVAL       S3RPTN = *BLANKS
     C                   EVAL       S3SWID = *BLANKS
     C                   EVAL       S3LEIC = *BLANKS
     C                   EVAL       S3CURR = *BLANKS
     C                   EVAL       S3CYDS = *BLANKS
     C                   EVAL       S3PMLI = *BLANKS
 
     C                   EXSR      SRKeyScrnV
 
     C                   IF        W#EROR = *BLANKS AND
     C                             *IN12 = *OFF AND
     C                             *IN03 = *OFF AND
     C                             WSEL = *BLANKS
     C                   EXSR      SRScrn2
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   IF        *IN03 = *ON OR *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRKeyScrnV - Validate Key Input Screen                        *
      *                                                               *
      *****************************************************************
     C     SRKeyScrnV    BEGSR
 
      ** Validate branch code
 
     C                   IF        S2BRCH = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C**********         EVAL      PZMsgID = 'USR0909'                                      MD021883
     C                   EVAL      PZMsgID = 'USR0906'                                      MD021883
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        W#EROR = *BLANKS AND
     C                             S2BRCH <> 'ALL'
 
     C                   MOVEL     S2BRCH        WSelFld
     C                   EXSR      SRChkSel
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    S2BRCH
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0137'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      S3BRCH = A8BRCD
     C                   EVAL      S3BRDS = A8BRNM
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      S3BRCH = 'ALL'
     C                   EVAL      S3BRDS = 'ALL BRANCHES'
     C                   ENDIF
 
      ** Validate transaction type
 
     C                   EVAL      *IN13 = *OFF                                             MD028088
     C                   EVAL      *IN14 = *OFF                                             MD028088
                                                                                            MD028088
     C                   IF        S2TYPE <> *BLANKS
     C                   Z-ADD     1             X
     C                   Z-ADD     1             Y
     C     S2TYPE        LOOKUP    FXDLAr(X)                              13
     C     S2TYPE        LOOKUP    FRAIRSAr(Y)                            14
 
     C                   IF        *IN13 = *OFF AND *IN14 = *OFF OR
     C                             *IN13 = *ON AND BGDLFX <> 'Y' OR
     C                             *IN14 = *ON AND BGFIIN <> 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0054'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C                   IF        *IN13 = *ON
     C                   EVAL      S3TYDS = FXDLDes(X)
     C                   ENDIF
 
     C                   IF        *IN14 = *ON
     C                   EVAL      S3TYDS = FRAIRSDes(Y)
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Validate transaction sub-type
 
     C                   IF        S2STPE <> *BLANKS
 
     C                   MOVEL     S2STPE        WSelFld
     C                   EXSR      SRChkSel
 
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    S2STPE
     C     SDDLST        PARM      SDDLST        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0135'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      S3STDS = ASDSTN
     C                   ENDIF
     C                   ENDIF
 
      ** Validate transaction type/sub-type combination
 
     C                   IF        S2STPE <> *BLANKS
 
     C     DTSTKY        KLIST
     C                   KFLD                    S2TYPE
     C                   KFLD                    S2STPE
 
     C     DTSTKY        CHAIN     FDDTSTL1
     C                   IF        NOT %FOUND(FDDTSTL1) OR
     C                             RCID11 = '*'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0136'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Validate counterparty (customer number/shortname)
 
     C                   IF        S2CUSN <> *BLANKS
 
     C                   MOVEL     S2CUSN        WSelFld
     C                   EXSR      SRChkSel
 
     C                   EVAL      PCUST = S2CUSN
     C                   EXSR      SrGetCusDtl
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0138'
     C                   EXSR      SRZasnms
 
     C                   ELSE
     C                   EVAL      S2CUSN = PCUST
     C                   EVAL      S3CUSN = BBCUST
     C                   EVAL      S3RPNM = BBCRNM
     C                   EVAL      S3RPTN = BBCRTN
     C                   EVAL      S3SWID = BBCSID
     C                   EVAL      S3LEIC = CSLEIC
 
     C                   ENDIF
     C                   ENDIF
 
      ** Validate currency code
 
     C                   IF        S2CURR <> *BLANKS
 
     C                   MOVEL     S2CURR        WSelFld
     C                   EXSR      SRChkSel
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    S2CURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN45 = *ON
     C                   EVAL      W#EROR = 'Y'
     C**********         EVAL      PZMsgID = 'USR0794'                                      MD021883
     C                   EVAL      PZMsgID = 'USR0949'                                      MD021883
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      S3CURR = A6CYCD
     C                   EVAL      S3CYDS = A6CYNM
     C                   ENDIF
     C                   ENDIF
 
      ** Validate precious metal indicator
 
     C                   IF        S2PMLI <> *BLANKS AND
     C                             S2CURR <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0155'
     C                   EXSR      SRZasnms
 
     C                   ELSE
     C                   IF        S2PMLI <> 'N' AND
     C                             S2PMLI <> 'Y' AND
     C                             S2PMLI <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0156'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      S3PMLI = S2PMLI
     C                   ENDIF
     C                   ENDIF
 
      ** Check for duplicate keys
 
     C                   EVAL      K1BRCH = S2BRCH
     C                   EVAL      K1TYPE = S2TYPE
     C                   EVAL      K1STPE = S2STPE
     C                   EVAL      K1CUSN = S2CUSN
     C                   EVAL      K1CURR = S2CURR
     C                   EVAL      K1PMLI = S2PMLI
 
     C                   IF        WSel = *BLANKS
     C     REPIKY        SETLL     SDRPIFL0
     C                   IF        %EQUAL
     C                   MOVE      '1111111'     *IN(40)
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0323'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend  - Process Amend                                      *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
 
     C                   EVAL      W#EROR = *BLANKS
 
     C                   EVAL      K1BRCH = S1BRCH
     C                   EVAL      K1TYPE = S1TYPE
     C                   EVAL      K1STPE = S1STPE
     C                   EVAL      K1CUSN = S1CUSN
     C                   EVAL      K1CURR = S1CURR
     C                   EVAL      K1PMLI = S1PMLI
 
     C     REPIKY        CHAIN     SDRPIFL0
     C                   IF        NOT %FOUND
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   GOTO      SrAmendE
     C                   ENDIF
 
      ** Amend is not allowed for deleted records
 
     C                   IF        RPRECI = '*'
     C**********         EVAL      PZMsgID = 'USR8703'                                      MD028258
     C**********         EXSR      SRZasnms                                                 MD028258
     C                   GOTO      SrAmendE
     C                   ENDIF
 
      ** Retrieve detail screen 2 details
 
     C                   EVAL      W1TMST = RPTMST
     C                   EXSR      SRScrn2Clr
     C                   EXSR      SRGetScrn2
 
     C                   EXSR      SRScrn2
 
     C                   IF        *IN03 = *ON OR *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
 
     C     SrAmendE      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Process Delete                                     *
      *                                                               *
      *****************************************************************
     C     SRDelete      BEGSR
 
     C                   EVAL      W#EROR3 = *BLANKS
 
     C                   EVAL      K1BRCH = S1BRCH
     C                   EVAL      K1TYPE = S1TYPE
     C                   EVAL      K1STPE = S1STPE
     C                   EVAL      K1CUSN = S1CUSN
     C                   EVAL      K1CURR = S1CURR
     C                   EVAL      K1PMLI = S1PMLI
 
     C     REPIKY        CHAIN     SDRPIFL0
     C                   IF        NOT %FOUND
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR7602'
     C                   EXSR      SRZasnms
     C                   GOTO      SrDeleteE
     C                   ENDIF
 
      ** Delete is not allowed for deleted records
 
     C                   IF        RPRECI = '*'
     C**********         EVAL      PZMsgID = 'USR8703'                                      MD028258
     C**********         EXSR      SRZasnms                                                 MD028258
     C                   GOTO      SRDeleteE
     C                   ENDIF
 
     C                   EVAL      W1TMST = RPTMST
     C                   EXSR      SRScrn2Clr
     C                   EXSR      SrGetScrn2
 
     C                   EVAL      W1RSF = 'N'
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN70 = *ON
     C**********         MOVEA     '0000000000'  *IN(47)                                      CSW214
     C                   MOVEA     '0000000'     *IN(47)                                      CSW214
     C                   MOVEA     '00'          *IN(96)                                      CSW214
 
     C                   EVAL      *IN11 = *OFF
     C                   IF        *IN14 = *ON
     C                   EVAL      *IN11 = *ON
     C                   ENDIF
 
     C                   DOW       *IN03 = *OFF AND *IN12 = *OFF AND
     C                             W1RSF = 'N' OR CAIN12 = *ON OR
     C                             *IN10 = *ON AND W#EROR3 = 'Y'
 
     C                   EVAL      CAIN12 = *OFF
     C                   EVAL      CAIN10 = *OFF
 
     C                   WRITE     SD000111C0
     C                   WRITE     SD000111F6
     C                   EXFMT     SD000111F3
 
     C                   IF        *IN03 = *OFF AND
     C                             *IN12 = *OFF AND
     C                             *IN10 = *OFF
     C                   EXSR      SrDelScr2
     C                   ENDIF
 
     C                   IF        CAIN10 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   ELSE
     C                   IF        *IN10 = *ON
     C                   EXSR      SrWrite
     C                   IF        W#EROR3 <> 'Y'
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
 
     C     SRDeleteE     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelScr2 - Display Delete Detail Screen 2                    *
      *                                                               *
      *****************************************************************
     C     SRDelScr2     BEGSR
 
     C                   EXSR      SRScrn3Clr
     C                   EXSR      SRGetScrn3
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN70 = *ON
 
     C                   MOVEA     '0000000000'  *IN(57)
     C**********         MOVEA     '000'         *IN(67)                                      CSW214
     C**********         MOVEA     '00000'       *IN(74)                                      CSW214
     C**********         MOVEA     '000'         *IN(22)                                      CSW214
     C**********         MOVEA     '00000'       *IN(26)                                      CSW214
     C**********         MOVEA     '00000'       *IN(33)                                      CSW214
     C                   MOVEA     '000'         *IN(54)                                      CSW214
     C                   MOVEA     '00000000'    *IN(88)                                      CSW214
     C                   MOVE      '0'           *IN67                                        CSW214
 
     C                   DOW       *IN03 = *OFF AND
     C                             *IN12 = *OFF AND
     C                             *IN10 = *OFF
     C                             OR CAIN12A = *ON                                           CSW214
     C                             OR *IN10 = *ON AND
     C                             W#EROR3 = 'Y'
 
     C                   EVAL      CAIN12A = *OFF                                             CSW214
     C                   WRITE     SD000111C0
     C                   WRITE     SD000111F6
     C                   EXFMT     SD000111F4
 
      ** If Enter key is pressed, go to detail screen 3                                       CSW214
                                                                                              CSW214
     C                   IF        *IN12 = *OFF AND *IN03 = *OFF                              CSW214
     C                   EXSR      SRDelScr3                                                  CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Reset CAIN12 to *OFF, if F3 was pressed                                              CSW214
     C                   IF        *IN03 = *ON                                                CSW214
     C                   EVAL      CAIN12 = *OFF                                              CSW214
     C                   ENDIF                                                                CSW214
      ** If F12 is pressed, go back to detail screen 1
 
     C                   IF        *IN12 = *ON
     C                   EVAL      CAIN12 = *IN12
     C                   ENDIF
 
     C                   IF        *IN10 = *ON
     C                   EXSR      SrWrite
 
      ** If no error during delete, go back to main screen
 
     C                   IF        WriteErr = *BLANKS
     C                   EVAL      CAIN10 = *IN10
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW214
      *                                                               *                       CSW214
      * SRDelScr3 - Display Delete Detail Screen 3                    *                       CSW214
      *                                                               *                       CSW214
      *****************************************************************                       CSW214
     C     SRDelScr3     BEGSR                                                                CSW214
     C                   EXSR      SRScrn4Clr                                                 CSW214
     C                   EXSR      SRGetScrn4                                                 CSW214
     C                   MOVEA     '00'          *IN(68)                                      CSW214
     C                   MOVEA     '00000'       *IN(74)                                      CSW214
     C                   MOVEA     '000'         *IN(22)                                      CSW214
     C                   MOVEA     '00000'       *IN(26)                                      CSW214
     C                   MOVEA     '00000'       *IN(33)                                      CSW214
     C                   DOW       *IN03 = *OFF AND                                           CSW214
     C                             *IN12 = *OFF AND                                           CSW214
     C                             *IN10 = *OFF                                               CSW214
     C                             OR *IN10 = *ON AND                                         CSW214
     C                             W#EROR3 = 'Y'                                              CSW214
                                                                                              CSW214
     C                   WRITE     SD000111C0                                                 CSW214
     C                   WRITE     SD000111F6                                                 CSW214
     C                   EXFMT     SD000111F7                                                 CSW214
                                                                                              CSW214
      ** If F12 is pressed, go back to detail screen 2                                        CSW214
                                                                                              CSW214
     C                   IF        *IN12 = *ON                                                CSW214
     C                   EVAL      CAIN12A = *IN12                                            CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   IF        *IN10 = *ON                                                CSW214
     C                   EXSR      SrWrite                                                    CSW214
                                                                                              CSW214
      ** If no error during delete, go back to main screen                                    CSW214
                                                                                              CSW214
     C                   IF        WriteErr = *BLANKS                                         CSW214
     C                   EVAL      CAIN10 = *IN10                                             CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDDO                                                                CSW214
     C                   ENDSR                                                                CSW214
      *****************************************************************                       CSW214
      /EJECT                                                                                  CSW214
      *****************************************************************
      *                                                               *
      * SRScrn2 - Process Detail Screen 1                             *
      *                                                               *
      *****************************************************************
     C     SRScrn2       BEGSR
 
     C**********         MOVEA     '0000000000'  *IN(47)                                      CSW214
     C                   MOVEA     '0000000'     *IN(47)                                      CSW214
     C                   MOVEA     '00'          *IN(96)                                      CSW214
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN70 = *OFF
 
     C                   EVAL      *IN11 = *OFF
     C                   IF        *IN14 = *ON
     C                   EVAL      *IN11 = *ON
     C                   ENDIF
 
     C                   IF        *IN09 = *ON
     C                   EVAL      S3TRID = *BLANKS
     C                   EVAL      S3TRNM = *BLANKS
     C                   EVAL      S3TRTN = *BLANKS
     C                   EVAL      S3TRSW = *BLANKS
     C                   EVAL      S3CCPN = *BLANKS
     C                   EVAL      S3CCPA = *BLANKS
     C                   EVAL      S3CPNM = *BLANKS
     C                   EVAL      S3CPTN = *BLANKS
     C                   EVAL      S3CPSW = *BLANKS
     C                   EVAL      S3CPLC = *BLANKS
     C                   EVAL      S3CCPP = *BLANKS
     C                   EVAL      S3CRPA = *BLANKS
     C                   EVAL      S3CRNM = *BLANKS
     C                   EVAL      S3CRTN = *BLANKS
     C                   EVAL      S3CRSW = *BLANKS
     C                   EVAL      S3CRLC = *BLANKS
     C                   EVAL      S3CBCL = *BLANKS
     C                   EVAL      S3CCPL = *BLANKS
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      S3CBRI = *BLANKS                                           CSW214
     C                   EVAL      S3CBRA = *BLANKS                                           CSW214
     C                   EVAL      S3CBNM = *BLANKS                                           CSW214
     C                   EVAL      S3CBTN = *BLANKS                                           CSW214
     C                   EVAL      S3CBSW = *BLANKS                                           CSW214
     C                   EVAL      S3CBLC = *BLANKS                                           CSW214
     C                   ENDIF                                                                CSW214
     C**********         EVAL      S3CPID = *BLANKS                                           CSW214
     C**********         EVAL      S3EXVE = *BLANKS                                           CSW214
     C**********         EVAL      S3UPID = *BLANKS                                           CSW214
     C                   ENDIF
 
     C                   EVAL      W1RKY = 'N'
     C                   EVAL      W#WARN = *BLANKS
     C                   EVAL      WARN = 0
 
     C                   DOW       *IN03 = *OFF AND
     C                             *IN12 = *OFF AND
     C                             W1RKY = 'N'
     C                             OR CAIN12 = *ON
     C                             OR WSEL = 'Y'
     C                             OR WARN = 1
 
     C                   EVAL      CAIN12 = *OFF
     C                   EVAL      WSEL = *BLANKS
     C                   EVAL      WSelFld = *BLANKS
     C                   WRITE     SD000111C0
     C                   WRITE     SD000111F6
     C                   EXFMT     SD000111F3
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      W#EROR2 = *BLANKS
     C                   EVAL      W#WARN = *BLANKS
     C**********         MOVEA     '0000000000'  *IN(47)                                      CSW214
     C                   MOVEA     '0000000'     *IN(47)                                      CSW214
     C                   MOVEA     '00'          *IN(96)                                      CSW214
 
      ** If Enter key is pressed, validate detail screen 2
 
     C                   IF        *IN03 = *OFF AND *IN12 = *OFF
     C                   EXSR      SRScrn2v
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
 
     C                   IF        W#WARN = 'Y' AND
     C                             W#EROR2 = *BLANKS
     C                   ADD       1             WARN              1 0
     C                   ELSE
     C                   EVAL      WARN = 0
     C                   ENDIF
 
     C                   IF        W#EROR2 = *BLANKS AND
     C                             *IN12 = *OFF AND
     C                             *IN03 = *OFF AND
     C                             WSEL = *BLANKS AND
     C                             WARN <> 1
 
     C                   CALL      'ZA0250'
     C                   EXSR      SrScrn3
     C                   ENDIF
 
     C                   ENDDO
 
      ** If F12 is pressed, go back to detail screen 1
 
     C                   IF        *IN12 = *ON
     C                   EVAL      CAIN12 = *IN12
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2Clr - Clear Detail Screen 1 fields                     *
      *                                                               *
      *****************************************************************
     C     SRScrn2Clr    BEGSR
 
     C                   EVAL      S3BRCH = *BLANKS
     C                   EVAL      S3BRDS = *BLANKS
     C                   EVAL      S3TYDS = *BLANKS
     C                   EVAL      S3STDS = *BLANKS
     C                   EVAL      S3CUSN = *BLANKS
     C                   EVAL      S3RPNM = *BLANKS
     C                   EVAL      S3RPTN = *BLANKS
     C                   EVAL      S3SWID = *BLANKS
     C                   EVAL      S3LEIC = *BLANKS
     C                   EVAL      S3CURR = *BLANKS
     C                   EVAL      S3CYDS = *BLANKS
     C                   EVAL      S3PMLI = *BLANKS
     C                   EVAL      S3TRID = *BLANKS
     C                   EVAL      S3TRNM = *BLANKS
     C                   EVAL      S3TRTN = *BLANKS
     C                   EVAL      S3TRSW = *BLANKS
     C                   EVAL      S3CCPN = *BLANKS
     C                   EVAL      S3CCPA = *BLANKS
     C                   EVAL      S3CPNM = *BLANKS
     C                   EVAL      S3CPTN = *BLANKS
     C                   EVAL      S3CPSW = *BLANKS
     C                   EVAL      S3CPLC = *BLANKS
     C                   EVAL      S3CCPP = *BLANKS
     C                   EVAL      S3CRPA = *BLANKS
     C                   EVAL      S3CRNM = *BLANKS
     C                   EVAL      S3CRTN = *BLANKS
     C                   EVAL      S3CRSW = *BLANKS
     C                   EVAL      S3CRLC = *BLANKS
     C                   EVAL      S3CBCL = *BLANKS
     C                   EVAL      S3CCPL = *BLANKS
     C**********         EVAL      S3CPID = *BLANKS                                           CSW214
     C**********         EVAL      S3EXVE = *BLANKS                                           CSW214
     C**********         EVAL      S3UPID = *BLANKS                                           CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      S3CBRI = *BLANKS                                           CSW214
     C                   EVAL      S3CBRA = *BLANKS                                           CSW214
     C                   EVAL      S3CBNM = *BLANKS                                           CSW214
     C                   EVAL      S3CBTN = *BLANKS                                           CSW214
     C                   EVAL      S3CBSW = *BLANKS                                           CSW214
     C                   EVAL      S3CBLC = *BLANKS                                           CSW214
     C                   ENDIF                                                                CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2v - Validate Detail Screeen 1 Details                  *
      *                                                               *
      *****************************************************************
     C     SRScrn2v      BEGSR
 
      ** Validate Trade Repository ID
 
     C                   IF        S3TRID = *BLANKS
     C                   IF        S3SWID = *BLANKS
     C                   EVAL      S3TRID = CtpyNonSwift
     C                   ELSE
     C                   EVAL      S3TRID = CtpySwift
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     S3TRID        WSelFld
     C                   EXSR      SRChkSel
 
     C                   IF        S3TRID <> *BLANKS                                        MD022288
     C                   EVAL      PCUST = S3TRID
     C                   EXSR      SrGetCusDtl
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN47 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR0157'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      S3TRID = BBCUST
     C                   EVAL      S3TRNM = BBCRNM
     C                   EVAL      S3TRTN = BBCRTN
     C                   EVAL      S3TRSW = BBCSID
     C                   IF        BBCSID = *BLANKS
     C                   EVAL      W#WARN = 'Y'
     C                   EVAL      PZMsgID = 'USR0158'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                              MD022288
 
      ** Validate Central Counterparty Clearing House (CCP) ID
 
     C                   IF        *IN13 = *ON OR
     C                             S2TYPE = *BLANKS
     C                   IF        S3CCPN <> *BLANKS
     C                   MOVEL     S3CCPN        WSelFld
     C                   EXSR      SRChkSel
     C                   EVAL      PCUST = S3CCPN
     C                   EXSR      SrGetCusDtl
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN48 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR0162'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      S3CCPN = BBCUST
     C                   EVAL      S3CPNM = BBCRNM
     C                   EVAL      S3CPTN = BBCRTN
     C                   EVAL      S3CPSW = BBCSID
     C                   EVAL      S3CPLC = CSLEIC
     C                   ENDIF
     C                   ENDIF
 
      ** Validate CCP House's Party ID
 
     C                   IF        S3CCPA <> *BLANKS
     C                   IF        S3CCPN = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN49 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR0165'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      FldChk = *BLANKS
     C                   MOVEL     S3CCPA        FldChk
     C                   EXSR      SrChkXSet
     C                   IF        *IN99 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN49 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR0179'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Clearing Exception Party
 
     C                   IF        S3CCPP <> *BLANKS
     C                   MOVEL     S3CCPP        WSelFld
     C                   EXSR      SRChkSel
     C                   EVAL      PCUST = S3CCPP
     C                   EXSR      SrGetCusDtl
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN50 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR0232'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      S3CCPP = BBCUST
     C                   EVAL      S3CRNM = BBCRNM
     C                   EVAL      S3CRTN = BBCRTN
     C                   EVAL      S3CRSW = BBCSID
     C                   EVAL      S3CRLC = CSLEIC
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Clearing Exception Party's Party ID
 
     C                   IF        S3CRPA <> *BLANKS
     C                   IF        S3CCPP = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN51 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR0234'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      FldChk = *BLANKS
     C                   MOVEL     S3CRPA        FldChk
     C                   EXSR      SrChkXSet
     C                   IF        *IN99 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN51 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR0237'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Clearing Broker ID Client Leg
 
     C                   IF        S3CBCL <> *BLANKS
     C                   EVAL      FldChk = *BLANKS
     C                   MOVEL     S3CBCL        FldChk
     C                   EXSR      SrChkXSet
     C                   IF        *IN99 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN52 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR0269'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Clearing Broker Identification CCP Leg
 
     C                   IF        S3CCPL <> *BLANKS
     C                   EVAL      FldChk = *BLANKS
     C                   MOVEL     S3CCPL        FldChk
     C                   EXSR      SrChkXSet
     C                   IF        *IN99 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN53 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR0304'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ***Validate*Cleared*Product*Identification                                              CSW214
      **********                                                                              CSW214
     C**********         IF        S3CPID <> *BLANKS                                          CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S3CPID        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN54 = *ON                                                CSW214
     C**********         EVAL      W#EROR2 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0304'                                      MD021883
     C**********         EVAL      PZMsgID = 'USR0305'                               MD021883 CSW214
     C**********         EXSR      SRZasnms                                                   CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
      **********                                                                              CSW214
      ***Validate*Execution*Value                                                             CSW214
      **********                                                                              CSW214
     C**********         IF        S3EXVE <> *BLANKS                                          CSW214
     C**********         MOVEL     S3EXVE        PEXVE                                        CSW214
     C**********         CALLB     'SDV0001'                                                  CSW214
     C**********         PARM                    PEXVE                                        CSW214
     C**********         PARM                    PEXVEOK                                      CSW214
     C**********         IF        PEXVEOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN55 = *ON                                                CSW214
     C**********         EVAL      W#EROR2 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0315'                                        CSW214
     C**********         EXSR      SRZasnms                                                   CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
      **********                                                                              CSW214
      ***Validate*Underlying*Product*Identifier                                               CSW214
      **********                                                                              CSW214
     C**********         IF        S3UPID <> *BLANKS                                          CSW214
      **********                                                                              CSW214
     C**********         Z-ADD     0             Z                                            CSW214
     C*****Alpha         CHECK     S3UPID        Z                      70                    CSW214
     C**********         IF        Z > 0                                                      CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN56 = *ON                                                CSW214
     C**********         EVAL      W#EROR2 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0316'                                        CSW214
     C**********         EXSR      SRZasnms                                                   CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   IF        *IN13 = *ON OR  S2TYPE = *BLANKS                           CSW214
                                                                                              CSW214
      ** Validate Clearing Broker                                                             CSW214
                                                                                              CSW214
     C                   IF        S3CBRI <> *BLANKS                                          CSW214
     C                   MOVEL     S3CBRI        WSelFld                                      CSW214
     C                   EXSR      SRChkSel                                                   CSW214
     C                   EVAL      PCUST = S3CBRI                                             CSW214
     C                   EXSR      SrGetCusDtl                                                CSW214
                                                                                              CSW214
     C                   IF        PRTCD <> *BLANKS                                           CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN97 = *ON                                                CSW214
     C                   EVAL      W#EROR2 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9038'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
      ** If invalid value, clear Clearing Broker details                                      CSW214
     C                   EVAL      S3CBNM = *BLANKS                                           CSW214
     C                   EVAL      S3CBTN = *BLANKS                                           CSW214
     C                   EVAL      S3CBSW = *BLANKS                                           CSW214
     C                   EVAL      S3CBLC = *BLANKS                                           CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      S3CBRI = BBCUST                                            CSW214
     C                   EVAL      S3CBNM = BBCRNM                                            CSW214
     C                   EVAL      S3CBTN = BBCRTN                                            CSW214
     C                   EVAL      S3CBSW = BBCSID                                            CSW214
     C                   EVAL      S3CBLC = CSLEIC                                            CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
      ** If blanks, clear Clearing Broker details                                             CSW214
     C                   EVAL      S3CBNM = *BLANKS                                           CSW214
     C                   EVAL      S3CBTN = *BLANKS                                           CSW214
     C                   EVAL      S3CBSW = *BLANKS                                           CSW214
     C                   EVAL      S3CBLC = *BLANKS                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Clearing Broker's Party ID                                                  CSW214
                                                                                              CSW214
     C                   IF        S3CBRA <> *BLANKS                                          CSW214
     C                   IF        S3CBRI = *BLANKS                                           CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN96 = *ON                                                CSW214
     C                   EVAL      W#EROR2 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9039'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S3CBRA        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN96 = *ON                                                CSW214
     C                   EVAL      W#EROR2 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9040'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn3 - Process Detail Screen 2                             *
      *                                                               *
      *****************************************************************
     C     SRScrn3       BEGSR
 
     C                   MOVEA     '0000000000'  *IN(57)
     C**********         MOVEA     '000'         *IN(67)                                      CSW214
     C**********         MOVEA     '00000'       *IN(74)                                      CSW214
     C**********         MOVEA     '000'         *IN(22)                                      CSW214
     C**********         MOVEA     '00000'       *IN(26)                                      CSW214
     C**********         MOVEA     '00000'       *IN(33)                                      CSW214
     C                   MOVEA     '000'         *IN(54)                                      CSW214
     C                   MOVEA     '00000000'    *IN(88)                                      CSW214
     C                   MOVE      '0'           *IN67                                        CSW214
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN70 = *OFF
 
     C                   IF        WSCR3 = 'N'                                                CSW214
     C                   EXSR      SRScrn3Clr
     C                   ENDIF                                                                CSW214
 
     C                   IF        *IN09 = *OFF
     C                             AND WSCR3 = 'N'                                            CSW214
     C                   EXSR      SrGetScrn3
     C                   ENDIF
 
     C                   EVAL      W1RD1 = 'N'
     C                   EVAL      W#AMT = *BLANKS
     C                   EVAL      WAMT = 0
     C                   EVAL      WARN = 0                                                 MD021923
 
     C                   DOW       *IN03 = *OFF AND
     C                             *IN12 = *OFF AND
     C                             W1RD1 = 'N'
     C                             OR CAIN12 = *ON
     C                             OR WSEL = 'Y'
     C                             OR WAMT = 1
     C                             OR WARN = 1                                              MD021923
 
     C                   EVAL      CAIN12 = *OFF
     C                   EVAL      WSEL = *BLANKS
     C                   EVAL      WSelFld = *BLANKS
     C                   WRITE     SD000111C0
     C                   WRITE     SD000111F6
     C                   EXFMT     SD000111F4
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      W#EROR3 = *BLANKS
     C                   EVAL      W#AMT = *BLANKS
     C                   EVAL      W#WARN = *BLANKS                                         MD021923
     C                   MOVEA     '0000000000'  *IN(57)
     C**********         MOVEA     '000'         *IN(67)                                      CSW214
     C**********         MOVEA     '00000'       *IN(74)                                      CSW214
     C**********         MOVEA     '000'         *IN(22)                                      CSW214
     C**********         MOVEA     '00000'       *IN(26)                                      CSW214
     C**********         MOVEA     '00000'       *IN(33)                                      CSW214
     C                   MOVEA     '000'         *IN(54)                                      CSW214
     C                   MOVEA     '00000000'    *IN(88)                                      CSW214
     C                   MOVE      '0'           *IN67                                        CSW214
 
      ** If Enter key is pressed, validate detail screen 2
 
     C                   IF        *IN03 = *OFF AND *IN12 = *OFF
     C                   EXSR      SRScrn3v
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
 
     C                   IF        W#AMT = 'Y' AND
     C                             W#EROR3 = *BLANKS
     C                   ADD       1             WAMT              1 0
     C                   ELSE
     C                   EVAL      WAMT = 0
     C                   ENDIF
                                                                                            MD021923
     C                   IF        W#WARN = 'Y' AND                                         MD021923
     C                             W#EROR3 = *BLANKS                                        MD021923
     C                   ADD       1             WARN                                       MD021923
     C                   ELSE                                                               MD021923
     C                   EVAL      WARN = 0                                                 MD021923
     C                   ENDIF                                                              MD021923
 
     C                   IF        W#EROR3 = *BLANKS AND
     C                             *IN12 = *OFF AND
     C                             *IN03 = *OFF AND
     C                             WSEL = *BLANKS AND
     C**********                   WAMT <> 1                                                MD021923
     C                             WAMT <> 1 AND WARN <> 1                                  MD021923
     C**********         EXSR      SRWrite                                                    CSW214
 
     C                   EXSR      SRScrn4                                                    CSW214
     C**********         IF        WriteErr = *BLANKS                                         CSW214
     C**********         EVAL      W1RD1 = 'Y'                                                CSW214
     C**********         EVAL      W1RKY = 'Y'                                                CSW214
     C**********         EVAL      W1RSF = 'Y'                                                CSW214
     C**********         ENDIF                                                                CSW214
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        *IN12 = *ON
     C                   EVAL      CAIN12 = *IN12
     C                   EVAL      WARN = 0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn3Clr - Clear Detail Screen 2 fields                     *
      *                                                               *
      *****************************************************************
     C     SRScrn3Clr    BEGSR
 
     C                   EVAL      S4CPID = *BLANKS                                           CSW214
     C                   EVAL      S4EXVE = *BLANKS                                           CSW214
     C                   EVAL      S4UPID = *BLANKS                                           CSW214
     C                   EVAL      S4RPJN = *BLANKS
     C                   EVAL      S4RPPY = *BLANKS
     C                   EVAL      S4RPAC = *BLANKS
     C                   EVAL      S4RPNM = *BLANKS
     C                   EVAL      S4RPTN = *BLANKS
     C                   EVAL      S4RPSW = *BLANKS
     C                   EVAL      S4RPLC = *BLANKS
     C                   EVAL      S4GTID = *BLANKS
     C                   EVAL      S4CTAM = *BLANKS
     C                   EVAL      S4CTCY = *BLANKS
     C                   EVAL      S4ALIN = *BLANKS
     C                   EVAL      S4CLIN = *BLANKS
     C                   EVAL      S4NSFL = *BLANKS
     C                   EVAL      S4EXDE = *BLANKS
     C                   EVAL      S4EXTC = *BLANKS
     C**********         EVAL      S4AD01 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD02 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD03 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD04 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD05 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD06 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD07 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD08 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD09 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD10 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD11 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD12 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD13 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD14 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD15 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD16 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD17 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD18 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD19 = *BLANKS                                           CSW214
     C**********         EVAL      S4AD20 = *BLANKS                                           CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      S4FNCI = *BLANKS                                           CSW214
     C                   EVAL      S4COPI = *BLANKS                                           CSW214
     C                   EVAL      S4COPC = *BLANKS                                           CSW214
     C                   EVAL      S4POCI = *BLANKS                                           CSW214
     C                   EVAL      S4COSI = *BLANKS                                           CSW214
     C                   EVAL      S4TNEI = *BLANKS                                           CSW214
     C                   EVAL      S4IGTI = *BLANKS                                           CSW214
     C                   EVAL      S4CTFI = *BLANKS                                           CSW214
     C                   ENDIF                                                                CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn3v - Validate Detail Screen 2 Details                   *
      *                                                               *
      *****************************************************************
     C     SRScrn3v      BEGSR
                                                                                              CSW214
      ** Validate Cleared Product Identification                                              CSW214
                                                                                              CSW214
     C                   IF        S4CPID <> *BLANKS                                          CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S4CPID        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN54 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR0305'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Execution Value                                                             CSW214
                                                                                              CSW214
     C                   IF        S4EXVE <> *BLANKS                                          CSW214
     C                   MOVEL     S4EXVE        PEXVE                                        CSW214
     C                   CALLB     'SDV0001'                                                  CSW214
     C                   PARM                    PEXVE                                        CSW214
     C                   PARM                    PEXVEOK                                      CSW214
     C                   IF        PEXVEOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN55 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR0315'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Underlying Product Identifier                                               CSW214
                                                                                              CSW214
     C                   IF        S4UPID <> *BLANKS                                          CSW214
                                                                                              CSW214
     C                   Z-ADD     0             Z                                            CSW214
     C     Alpha         CHECK     S4UPID        Z                      70                    CSW214
     C                   IF        Z > 0                                                      CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN56 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR0316'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
 
      ** Validate Reporting Jurisdiction
 
     C                   IF        S4RPJN <> *BLANKS
     C                   EVAL      FldChk = *BLANKS
     C                   MOVEL     S4RPJN        FldChk
     C                   EXSR      SrChkXSet
     C                   IF        *IN99 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN57 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0338'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Reporting Party
 
     C                   IF        S4RPPY <> *BLANKS
     C                   IF        S4RPJN = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN57 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0385'
     C                   EXSR      SRZasnms
 
     C                   ELSE
     C                   MOVEL     S4RPPY        WSelFld
     C                   EXSR      SRChkSel
     C                   EVAL      PCUST = S4RPPY
     C                   EXSR      SrGetCusDtl
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN58 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0386'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      S4RPPY = BBCUST
     C                   EVAL      S4RPNM = BBCRNM
     C                   EVAL      S4RPTN = BBCRTN
     C                   EVAL      S4RPSW = BBCSID
     C                   EVAL      S4RPLC = CSLEIC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Reporting Party's Party ID
 
     C                   IF        S4RPAC <> *BLANKS
     C                   IF        S4RPPY = *BLANKS
      *
      ** Default to Branch Internal Customer number
      ** of the branch if not set to 'ALL'
      *
     C                   IF        S3BRCH <> 'ALL'
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    S3BRCH
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S4RPPY = A8BICN
 
     C                   EVAL      PCUST = S4RPPY
     C                   EXSR      SrGetCusDtl
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN58 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0386'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      S4RPPY = BBCUST
     C                   EVAL      S4RPNM = BBCRNM
     C                   EVAL      S4RPTN = BBCRTN
     C                   EVAL      S4RPSW = BBCSID
     C                   EVAL      S4RPLC = CSLEIC
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN59 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0495'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDIF                                                              MD027482
     C**********         ELSE                                                               MD027482
     C                   EVAL      FldChk = *BLANKS
     C                   MOVEL     S4RPAC        FldChk
     C                   EXSR      SrChkXSet
     C                   IF        *IN99 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN59 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0496'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C**********         ENDIF                                                              MD027482
     C                   ENDIF
 
      ** Validate Generate Transaction Identifier
 
     C                   IF        S4GTID <> *BLANKS AND
     C                             S4GTID <> 'Y' AND
     C                             S4GTID <> 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN60 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0497'
     C                   EXSR      SRZasnms
 
     C                   ELSE
     C                   IF        S4GTID = 'Y' AND
     C                             S4RPJN = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN57 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0498'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Clearing Threshold Currency
 
     C                   IF        S4CTCY = *BLANKS
     C                   IF        S4CTAM <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN62 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0503'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ELSE
     C                   IF        S4CTAM = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN62 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0512'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   MOVEL     S4CTCY        WSelFld
     C                   EXSR      SRChkSel
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    S4CTCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN62 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0520'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      CurrencyOK = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Clearing Threshold Amount
 
     C                   MOVE      S4CTAM        W4CTAM
 
     C                   IF        CurrencyOK = 'Y'
     C                   IF        S4CTAM <> *BLANKS
     C                   EVAL      W4CTAM = S4CTAM
     C                   Z-ADD     A6NBDP        IDP               3 0
     C     15            SUB       A6NBDP        IINT              3 0
     C                   MOVE      *BLANKS       ALPH             16
     C                   MOVE      S4CTAM        ALPH
     C                   MOVE      'Y'           MTID              1
     C                   MOVE      '.'           BNDCSP            1
 
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    ALPH
     C                   PARM                    IDP
     C                   PARM                    IINT
     C                   PARM                    MTID
     C                   PARM                    ERCD
     C                   PARM                    AMNT
     C                   PARM                    BNDCSP
 
     C                   IF        ERCD = 0
     C                   MOVE      ALPH          S4CTAM
     C                   IF        W4CTAM <> S4CTAM
     C                   EVAL      W#AMT = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN61 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0522'
     C                   EVAL      PZMsgFile = 'GBSDUSRMSG'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Allocation Indicator
 
     C                   IF        S4ALIN <> *BLANKS AND
     C                             S4ALIN <> 'A' AND
     C                             S4ALIN <> 'P' AND
     C                             S4ALIN <> 'U'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN63 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0527'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Validate Collateralisation Indicator
 
     C                   IF        S4CLIN <> *BLANKS AND
     C                             S4CLIN <> 'F' AND
     C                             S4CLIN <> 'O' AND
     C                             S4CLIN <> 'P' AND
     C                             S4CLIN <> 'U'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN64 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0538'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Validate Non Standard Flag
 
     C                   IF        S4NSFL <> *BLANKS AND
     C                             S4NSFL <> 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN65 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0734'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Validate Execution Timestamp (Date/Time)
 
     C                   IF        S4EXDE <> 'Y' AND
     C                             S4EXDE <> 'N' AND
     C                             S4EXDE <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN66 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0642'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        S4EXDE = *BLANKS AND
     C                             S4EXTC <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN66 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0643'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Validate Execution Timestamp (UTC)
 
     C                   IF        S4EXTC <> 'Y' AND
     C                             S4EXTC <> 'N' AND
     C                             S4EXTC <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN67 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0649'
     C                   EXSR      SRZasnms
 
     C                   ELSE
     C                   IF        S4EXTC = 'Y' AND
     C                             S4EXDE = 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN67 = *ON
     C                   EVAL      W#EROR3 = 'Y'
     C                   EVAL      PZMsgID = 'USR0650'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Additional Information
 
     C**********         IF        AddlRepiDS = *BLANKS                                       CSW214
     C**********         IF        S4RPJN = 'OTHR'                                            CSW214
     C**********         EVAL      PZMsgID = 'USR0651'                                        CSW214
     C**********         EVAL      W#WARN = 'Y'                                      MD021923 CSW214
     C**********         EXSR      SRZasnms                                                   CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      EmbdBlanks = *BLANKS                                       CSW214
     C**********         EVAL      SWIFTChar = *BLANKS                                        CSW214
     C**********         EVAL      CodeWordCnt = 0                                  MD023614A CSW214
     C**********         EVAL      SlashCnt = 0                                     MD023614A CSW214
 
      ***Additional*Information*1                                                             CSW214
 
     C**********         IF        S4AD01 = *BLANKS                                           CSW214
     C**********         IF        S4AD02 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN68 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD01        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN68 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD01        CWordChk                                     CSW214
     C**********         EVAL      Line1 = 'Y'                                                CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N'                                           CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN68 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0674'                                        CSW214
     C**********         EXSR      SRZasnms                                                   CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*2                                                             CSW214
 
     C**********         IF        S4AD02 = *BLANKS                                           CSW214
     C**********         IF        S4AD03 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN69 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD02        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN69 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD02        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN69 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '2nd'                                        MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*3                                                             CSW214
 
     C**********         IF        S4AD03 = *BLANKS                                           CSW214
     C**********         IF        S4AD04 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN74 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD03        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN74 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD03        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN74 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '3rd'                                        MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*4                                                             CSW214
 
     C**********         IF        S4AD04 = *BLANKS                                           CSW214
     C**********         IF        S4AD05 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN75 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD04        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN75 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD04        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN75 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '4th'                                        MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*5                                                             CSW214
 
     C**********         IF        S4AD05 = *BLANKS                                           CSW214
     C**********         IF        S4AD06 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN76 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD05        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN76 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD05        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN76 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '5th'                                        MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*6                                                             CSW214
 
     C**********         IF        S4AD06 = *BLANKS                                           CSW214
     C**********         IF        S4AD07 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN77 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD06        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN77 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD06        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN77 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '6th'                                        MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*7                                                             CSW214
 
     C**********         IF        S4AD07 = *BLANKS                                           CSW214
     C**********         IF        S4AD08 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN78 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD07        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN78 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD07        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN78 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '7th'                                        MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*8                                                             CSW214
 
     C**********         IF        S4AD08 = *BLANKS                                           CSW214
     C**********         IF        S4AD09 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN22 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD08        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN22 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD08        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN22 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '8th'                                        MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*9                                                             CSW214
 
     C**********         IF        S4AD09 = *BLANKS                                           CSW214
     C**********         IF        S4AD10 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN10 = *ON                                              MD023614
     C**********         EVAL      *IN23 = *ON                                       MD023614 CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD09        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN10 = *ON                                              MD023614
     C**********         EVAL      *IN23 = *ON                                       MD023614 CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD09        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN10 = *ON                                              MD023614
     C**********         EVAL      *IN23 = *ON                                       MD023614 CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '9th'                                        MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*10                                                            CSW214
 
     C**********         IF        S4AD10 = *BLANKS                                           CSW214
     C**********         IF        S4AD11 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN24 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD10        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN24 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD10        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN24 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '10th'                                       MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*11                                                            CSW214
 
     C**********         IF        S4AD11 = *BLANKS                                           CSW214
     C**********         IF        S4AD12 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN26 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD11        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN26 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD11        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN26 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '11th'                                       MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*12                                                            CSW214
 
     C**********         IF        S4AD12 = *BLANKS                                           CSW214
     C**********         IF        S4AD13 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN27 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD12        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN27 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD12        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN27 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '12th'                                       MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*13                                                            CSW214
 
     C**********         IF        S4AD13 = *BLANKS                                           CSW214
     C**********         IF        S4AD14 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN28 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD13        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN28 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD13        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN28 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '13th'                                       MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*14                                                            CSW214
 
     C**********         IF        S4AD14 = *BLANKS                                           CSW214
     C**********         IF        S4AD15 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN29 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD14        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN29 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD14        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN29 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '14th'                                       MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*15                                                            CSW214
 
     C**********         IF        S4AD15 = *BLANKS                                           CSW214
     C**********         IF        S4AD16 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN30 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD15        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN30 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD15        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN30 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '15th'                                       MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*16                                                            CSW214
 
     C**********         IF        S4AD16 = *BLANKS                                           CSW214
     C**********         IF        S4AD17 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN33 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD16        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN33 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD16        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN33 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '16th'                                       MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*17                                                            CSW214
 
     C**********         IF        S4AD17 = *BLANKS                                           CSW214
     C**********         IF        S4AD18 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN34 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD17        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN34 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD17        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN34 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '17th'                                       MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*18                                                            CSW214
 
     C**********         IF        S4AD18 = *BLANKS                                           CSW214
     C**********         IF        S4AD19 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN35 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD18        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN35 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD18        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN35 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '18th'                                       MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*19                                                            CSW214
 
     C**********         IF        S4AD19 = *BLANKS                                           CSW214
     C**********         IF        S4AD20 <> *BLANKS                                          CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN36 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      EmbdBlanks = 'Y'                                           CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD19        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN36 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD19        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN36 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '19th'                                       MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
      ***Additional*Information*20                                                            CSW214
 
     C**********         IF        S4AD20 <> *BLANKS                                          CSW214
     C**********         EVAL      FldChk = *BLANKS                                           CSW214
     C**********         MOVEL     S4AD20        FldChk                                       CSW214
     C**********         EXSR      SrChkXSet                                                  CSW214
     C**********         IF        *IN99 = *ON                                                CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN37 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      SWIFTChar = 'N'                                            CSW214
     C**********         ELSE                                                                 CSW214
     C**********         EVAL      CWordChk = *BLANKS                                         CSW214
     C**********         MOVEL     S4AD20        CWordChk                                     CSW214
     C**********         EXSR      SrCodeWord                                                 CSW214
     C**********         IF        CodeWordOK = 'N' AND                                       CSW214
     C**********                   SlashOK = 'N'                                              CSW214
     C**********         EVAL      *IN40 = *ON                                                CSW214
     C**********         EVAL      *IN37 = *ON                                                CSW214
     C**********         EVAL      W#EROR3 = 'Y'                                              CSW214
     C**********         EVAL      PZMsgID = 'USR0675'                                      MD021931
     C**********         EVAL      PZMsgData = '20th'                                       MD021931
     C**********         EXSR      SRZasnms2                                                MD021931
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         IF        EmbdBlanks = 'Y'                                         MD021931
     C**********         IF        EmbdBlanks = 'Y' OR                               MD021931 CSW214
     C**********                   CodeWordCnt > 0  AND                             MD023614A CSW214
     C**********                   SlashCnt > 0                                     MD023614A CSW214
     C**********                   CodeWordOK = 'N' AND                           MD021931 MD023614A
     C**********                   SlashOK = 'N'                                  MD021931 MD023614A
     C**********         EVAL      PZMsgID = 'USR0676'                                      MD021931
     C**********         EVAL      PZMsgID = 'USR0675'                               MD021931 CSW214
     C**********         EXSR      SRZasnms                                                   CSW214
     C**********         ENDIF                                                                CSW214
 
     C**********         IF        SWIFTChar = 'N'                                            CSW214
     C**********         EVAL      PZMsgID = 'USR0652'                                        CSW214
     C**********         EXSR      SRZasnms                                                   CSW214
     C**********         ENDIF                                                                CSW214
     C**********         ENDIF                                                                CSW214
 
     C                   IF        CSW214 = 'Y'                                               CSW214
                                                                                              CSW214
      ** Validate Financial Nature of the Counterparty Indicator                              CSW214
                                                                                              CSW214
     C                   IF        S4FNCI <> *BLANKS AND                                      CSW214
     C                             S4FNCI <> 'F' AND                                          CSW214
     C                             S4FNCI <> 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN95 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9041'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Collateral Portfolio Indicator                                              CSW214
                                                                                              CSW214
     C                   IF        S4COPI <> *BLANKS AND                                      CSW214
     C                             S4COPI <> 'N' AND                                          CSW214
     C                             S4COPI <> 'Y'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN94 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9042'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Collateral Portfolio Code                                                   CSW214
                                                                                              CSW214
     C                   IF        S4COPC <> *BLANKS                                          CSW214
                                                                                              CSW214
     C                   IF        S4COPI <> 'Y'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN93 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9043'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
                                                                                              CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S4COPC        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
                                                                                              CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN93 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9044'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   IF        S4COPI = 'Y'                                               CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN93 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9045'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Portfolio Compression Indicator                                             CSW214
                                                                                              CSW214
     C                   IF        S4POCI <> *BLANKS AND                                      CSW214
     C                             S4POCI <> 'Y' AND                                          CSW214
     C                             S4POCI <> 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN92 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9046'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
                                                                                              CSW214
      ** Validate Corporate Sector Indicator                                                  CSW214
                                                                                              CSW214
     C                   IF        S4COSI <> *BLANKS AND                                      CSW214
     C                             S4COSI <> 'A' AND                                          CSW214
     C                             S4COSI <> 'C' AND                                          CSW214
     C                             S4COSI <> 'F' AND                                          CSW214
     C                             S4COSI <> 'I' AND                                          CSW214
     C                             S4COSI <> 'L' AND                                          CSW214
     C                             S4COSI <> 'O' AND                                          CSW214
     C                             S4COSI <> 'R' AND                                          CSW214
     C                             S4COSI <> 'U'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN91 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9047'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Trade with Non-EEA Counterparty Indicator                                   CSW214
                                                                                              CSW214
     C                   IF        S4TNEI <> *BLANKS AND                                      CSW214
     C                             S4TNEI <> 'Y' AND                                          CSW214
     C                             S4TNEI <> 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN90 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9048'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Intragroup Trade Indicator                                                  CSW214
                                                                                              CSW214
     C                   IF        S4IGTI <> *BLANKS AND                                      CSW214
     C                             S4IGTI <> 'Y' AND                                          CSW214
     C                             S4IGTI <> 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN89 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9049'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Commercial or Treasury Financial Indicator                                  CSW214
                                                                                              CSW214
     C                   IF        S4CTFI <> *BLANKS AND                                      CSW214
     C                             S4CTFI <> 'Y' AND                                          CSW214
     C                             S4CTFI <> 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN88 = *ON                                                CSW214
     C                   EVAL      W#EROR3 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR9050'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW214
      *                                                               *                       CSW214
      * SRScrn4Clr - Clear Detail Screen 3 fields                     *                       CSW214
      *                                                               *                       CSW214
      *****************************************************************                       CSW214
     C     SRScrn4Clr    BEGSR                                                                CSW214
     C                   EVAL      S7AD01 = *BLANKS                                           CSW214
     C                   EVAL      S7AD02 = *BLANKS                                           CSW214
     C                   EVAL      S7AD03 = *BLANKS                                           CSW214
     C                   EVAL      S7AD04 = *BLANKS                                           CSW214
     C                   EVAL      S7AD05 = *BLANKS                                           CSW214
     C                   EVAL      S7AD06 = *BLANKS                                           CSW214
     C                   EVAL      S7AD07 = *BLANKS                                           CSW214
     C                   EVAL      S7AD08 = *BLANKS                                           CSW214
     C                   EVAL      S7AD09 = *BLANKS                                           CSW214
     C                   EVAL      S7AD10 = *BLANKS                                           CSW214
     C                   EVAL      S7AD11 = *BLANKS                                           CSW214
     C                   EVAL      S7AD12 = *BLANKS                                           CSW214
     C                   EVAL      S7AD13 = *BLANKS                                           CSW214
     C                   EVAL      S7AD14 = *BLANKS                                           CSW214
     C                   EVAL      S7AD15 = *BLANKS                                           CSW214
     C                   EVAL      S7AD16 = *BLANKS                                           CSW214
     C                   EVAL      S7AD17 = *BLANKS                                           CSW214
     C                   EVAL      S7AD18 = *BLANKS                                           CSW214
     C                   EVAL      S7AD19 = *BLANKS                                           CSW214
     C                   EVAL      S7AD20 = *BLANKS                                           CSW214
     C                   ENDSR                                                                CSW214
      *****************************************************************                       CSW214
      /EJECT                                                                                  CSW214
      *****************************************************************                       CSW214
      *                                                               *                       CSW214
      * SRScrn4v - Validate Detail Screen 3 Details                   *                       CSW214
      *                                                               *                       CSW214
      *****************************************************************                       CSW214
     C     SRScrn4v      BEGSR                                                                CSW214
                                                                                              CSW214
      ** Additional Information                                                               CSW214
                                                                                              CSW214
     C                   IF        AddlRepiDS = *BLANKS                                       CSW214
     C                   IF        S4RPJN = 'OTHR'                                            CSW214
     C                   EVAL      PZMsgID = 'USR0651'                                        CSW214
     C                   EVAL      W#WARN = 'Y'                                               CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
                                                                                              CSW214
      ** Additional Information 1                                                             CSW214
                                                                                              CSW214
     C                   IF        S7AD01 = *BLANKS                                           CSW214
     C                   IF        S7AD02 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN68 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD01        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN68 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD01        CWordChk                                     CSW214
     C                   EVAL      Line1 = 'Y'                                                CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N'                                           CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN68 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR0674'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 2                                                             CSW214
                                                                                              CSW214
     C                   IF        S7AD02 = *BLANKS                                           CSW214
     C                   IF        S7AD03 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN69 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD02        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN69 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD02        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN69 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 3                                                             CSW214
                                                                                              CSW214
     C                   IF        S7AD03 = *BLANKS                                           CSW214
     C                   IF        S7AD04 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN74 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD03        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN74 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD03        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN74 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 4                                                             CSW214
                                                                                              CSW214
     C                   IF        S7AD04 = *BLANKS                                           CSW214
     C                   IF        S7AD05 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN75 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD04        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN75 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD04        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN75 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 5                                                             CSW214
                                                                                              CSW214
     C                   IF        S7AD05 = *BLANKS                                           CSW214
     C                   IF        S7AD06 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN76 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD05        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN76 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD05        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN76 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 6                                                             CSW214
                                                                                              CSW214
     C                   IF        S7AD06 = *BLANKS                                           CSW214
     C                   IF        S7AD07 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN77 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD06        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN77 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD06        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN77 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 7                                                             CSW214
                                                                                              CSW214
     C                   IF        S7AD07 = *BLANKS                                           CSW214
     C                   IF        S7AD08 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN78 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD07        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN78 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD07        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN78 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 8                                                             CSW214
                                                                                              CSW214
     C                   IF        S7AD08 = *BLANKS                                           CSW214
     C                   IF        S7AD09 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN22 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD08        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN22 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD08        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN22 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 9                                                             CSW214
                                                                                              CSW214
     C                   IF        S7AD09 = *BLANKS                                           CSW214
     C                   IF        S7AD10 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN23 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD09        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN23 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD09        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN23 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 10                                                            CSW214
                                                                                              CSW214
     C                   IF        S7AD10 = *BLANKS                                           CSW214
     C                   IF        S7AD11 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN24 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD10        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN24 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD10        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN24 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 11                                                            CSW214
                                                                                              CSW214
     C                   IF        S7AD11 = *BLANKS                                           CSW214
     C                   IF        S7AD12 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN26 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD11        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN26 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD11        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN26 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 12                                                            CSW214
                                                                                              CSW214
     C                   IF        S7AD12 = *BLANKS                                           CSW214
     C                   IF        S7AD13 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN27 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD12        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN27 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD12        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN27 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 13                                                            CSW214
                                                                                              CSW214
     C                   IF        S7AD13 = *BLANKS                                           CSW214
     C                   IF        S7AD14 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN28 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD13        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN28 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD13        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN28 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 14                                                            CSW214
                                                                                              CSW214
     C                   IF        S7AD14 = *BLANKS                                           CSW214
     C                   IF        S7AD15 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN29 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD14        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN29 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD14        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN29 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 15                                                            CSW214
                                                                                              CSW214
     C                   IF        S7AD15 = *BLANKS                                           CSW214
     C                   IF        S7AD16 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN30 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD15        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN30 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD15        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN30 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 16                                                            CSW214
                                                                                              CSW214
     C                   IF        S7AD16 = *BLANKS                                           CSW214
     C                   IF        S7AD17 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN33 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD16        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN33 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD16        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN33 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 17                                                            CSW214
                                                                                              CSW214
     C                   IF        S7AD17 = *BLANKS                                           CSW214
     C                   IF        S7AD18 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN34 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD17        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN34 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD17        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN34 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 18                                                            CSW214
                                                                                              CSW214
     C                   IF        S7AD18 = *BLANKS                                           CSW214
     C                   IF        S7AD19 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN35 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD18        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN35 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD18        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN35 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 19                                                            CSW214
                                                                                              CSW214
     C                   IF        S7AD19 = *BLANKS                                           CSW214
     C                   IF        S7AD20 <> *BLANKS                                          CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN36 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      EmbdBlanks = 'Y'                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD19        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN36 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD19        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN36 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Additional Information 20                                                            CSW214
                                                                                              CSW214
     C                   IF        S7AD20 <> *BLANKS                                          CSW214
     C                   EVAL      FldChk = *BLANKS                                           CSW214
     C                   MOVEL     S7AD20        FldChk                                       CSW214
     C                   EXSR      SrChkXSet                                                  CSW214
     C                   IF        *IN99 = *ON                                                CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN37 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   EVAL      SWIFTChar = 'N'                                            CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CWordChk = *BLANKS                                         CSW214
     C                   MOVEL     S7AD20        CWordChk                                     CSW214
     C                   EXSR      SrCodeWord                                                 CSW214
     C                   IF        CodeWordOK = 'N' AND                                       CSW214
     C                             SlashOK = 'N'                                              CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN37 = *ON                                                CSW214
     C                   EVAL      W#EROR4 = 'Y'                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   IF        EmbdBlanks = 'Y' OR                                        CSW214
     C                             CodeWordCnt > 0  AND                                       CSW214
     C                             SlashCnt > 0                                               CSW214
     C                   EVAL      PZMsgID = 'USR0675'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   IF        SWIFTChar = 'N'                                            CSW214
     C                   EVAL      PZMsgID = 'USR0652'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDSR                                                                CSW214
      *****************************************************************                       CSW214
      /EJECT                                                                                  CSW214
      *****************************************************************                       CSW214
      *                                                               *                       CSW214
      * SRGetScrn4 - Retrieve Detail Screen 3 Details                 *                       CSW214
      *                                                               *                       CSW214
      *****************************************************************                       CSW214
     C     SRGetScrn4    BEGSR                                                                CSW214
     C                   EVAL      S7AD01 = RPAD01                                            CSW214
     C                   EVAL      S7AD02 = RPAD02                                            CSW214
     C                   EVAL      S7AD03 = RPAD03                                            CSW214
     C                   EVAL      S7AD04 = RPAD04                                            CSW214
     C                   EVAL      S7AD05 = RPAD05                                            CSW214
     C                   EVAL      S7AD06 = RPAD06                                            CSW214
     C                   EVAL      S7AD07 = RPAD07                                            CSW214
     C                   EVAL      S7AD08 = RPAD08                                            CSW214
     C                   EVAL      S7AD09 = RPAD09                                            CSW214
     C                   EVAL      S7AD10 = RPAD10                                            CSW214
     C                   EVAL      S7AD11 = RPAD11                                            CSW214
     C                   EVAL      S7AD12 = RPAD12                                            CSW214
     C                   EVAL      S7AD13 = RPAD13                                            CSW214
     C                   EVAL      S7AD14 = RPAD14                                            CSW214
     C                   EVAL      S7AD15 = RPAD15                                            CSW214
     C                   EVAL      S7AD16 = RPAD16                                            CSW214
     C                   EVAL      S7AD17 = RPAD17                                            CSW214
     C                   EVAL      S7AD18 = RPAD18                                            CSW214
     C                   EVAL      S7AD19 = RPAD19                                            CSW214
     C                   EVAL      S7AD20 = RPAD20                                            CSW214
     C                   ENDSR                                                                CSW214
      *****************************************************************                       CSW214
      /EJECT                                                                                  CSW214
      *****************************************************************                       CSW214
      *                                                               *                       CSW214
      * SRScrn4 - Process Detail Screen 3                             *                       CSW214
      *                                                               *                       CSW214
      *****************************************************************                       CSW214
     C     SRScrn4       BEGSR                                                                CSW214
                                                                                              CSW214
     C                   MOVEA     '00'          *IN(68)                                      CSW214
     C                   MOVEA     '00000'       *IN(74)                                      CSW214
     C                   MOVEA     '000'         *IN(22)                                      CSW214
     C                   MOVEA     '00000'       *IN(26)                                      CSW214
     C                   MOVEA     '00000'       *IN(33)                                      CSW214
                                                                                              CSW214
     C                   EVAL      *IN20 = *ON                                                CSW214
     C                   EVAL      *IN70 = *OFF                                               CSW214
     C                   EVAL      W1RD3 = 'N'                                                CSW214
     C                   EVAL      WSCR3 = 'Y'                                                CSW214
                                                                                              CSW214
     C                   EXSR      SRScrn4Clr                                                 CSW214
                                                                                              CSW214
     C                   IF        *IN09 = *OFF                                               CSW214
     C                   EXSR      SrGetScrn4                                                 CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   EVAL      W1RD1 = 'N'                                                CSW214
     C                   EVAL      WARN = 0                                                   CSW214
                                                                                              CSW214
     C                   DOW       *IN03 = *OFF AND                                           CSW214
     C                             *IN12 = *OFF AND                                           CSW214
     C                             W1RD3 = 'N'                                                CSW214
     C                             OR CAIN12 = *ON                                            CSW214
     C                             OR WARN = 1                                                CSW214
                                                                                              CSW214
     C                   EVAL      CAIN12 = *OFF                                              CSW214
     C                   WRITE     SD000111C0                                                 CSW214
     C                   WRITE     SD000111F6                                                 CSW214
     C                   EXFMT     SD000111F7                                                 CSW214
                                                                                              CSW214
      ** Clear messages from program message queue                                            CSW214
                                                                                              CSW214
     C                   CALL      'ZA0250'                                                   CSW214
     C                   EVAL      *IN40 = *OFF                                               CSW214
     C                   EVAL      W#EROR4 = *BLANKS                                          CSW214
     C                   EVAL      W#WARN = *BLANKS                                           CSW214
     C                   MOVEA     '00'          *IN(68)                                      CSW214
     C                   MOVEA     '00000'       *IN(74)                                      CSW214
     C                   MOVEA     '000'         *IN(22)                                      CSW214
     C                   MOVEA     '00000'       *IN(26)                                      CSW214
     C                   MOVEA     '00000'       *IN(33)                                      CSW214
                                                                                              CSW214
      ** If Enter key is pressed, validate detail screen 3                                    CSW214
                                                                                              CSW214
     C                   IF        *IN03 = *OFF AND *IN12 = *OFF                              CSW214
     C                   EXSR      SRScrn4v                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   IF        *IN03 = *ON                                                CSW214
     C                   EVAL      W1RSF = 'Y'                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   IF        W#WARN = 'Y' AND                                           CSW214
     C                             W#EROR4 = *BLANKS                                          CSW214
     C                   ADD       1             WARN                                         CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      WARN = 0                                                   CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   IF        W#EROR4 = *BLANKS AND                                      CSW214
     C                             *IN12 = *OFF AND                                           CSW214
     C                             *IN03 = *OFF AND                                           CSW214
     C                             WARN <> 1                                                  CSW214
     C                   EXSR      SRWrite                                                    CSW214
                                                                                              CSW214
     C                   IF        WriteErr = *BLANKS                                         CSW214
     C                   EVAL      W1RD1 = 'Y'                                                CSW214
     C                   EVAL      W1RD3 = 'Y'                                                CSW214
     C                   EVAL      W1RKY = 'Y'                                                CSW214
     C                   EVAL      W1RSF = 'Y'                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDDO                                                                CSW214
                                                                                              CSW214
     C                   IF        *IN12 = *ON                                                CSW214
     C                   EVAL      CAIN12 = *IN12                                             CSW214
     C                   EVAL      WARN = 0                                                   CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDSR                                                                CSW214
      *****************************************************************                       CSW214
      /EJECT                                                                                  CSW214
      *****************************************************************
      *                                                               *
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      *****************************************************************
     C     SRReload      BEGSR
 
      ** Request subfile reload
 
     C                   EVAL      W1RSF = 'Y'
 
     C                   IF        *IN05 = *ON
     C                   EVAL      S1ACTN = *BLANKS
     C                   EVAL      S1BRCH = *BLANKS
     C                   EVAL      S1TYPE = *BLANKS
     C                   EVAL      S1STPE = *BLANKS
     C                   EVAL      S1CUSN = *BLANKS
     C                   EVAL      S1CURR = *BLANKS
     C                   EVAL      S1PMLI = *BLANKS
     C                   EVAL      S1RPNM = *BLANKS
     C                   EVAL      S1RPTN = *BLANKS
 
     C                   EVAL      SEBRCH = *BLANKS
     C                   EVAL      SETYPE = *BLANKS
     C                   EVAL      SESTPE = *BLANKS
     C                   EVAL      SECURR = *BLANKS
     C                   EVAL      SEPMLI = *BLANKS
     C                   EVAL      SECUSN = *BLANKS                                         MD030328
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrScrn - Initialise Subfile Record                         *
      *                                                               *
      *****************************************************************
     C     SRClrScrn     BEGSR
 
      ** Initialise subfile record
 
     C                   EVAL      S1ACTN = *BLANKS
     C                   EVAL      S1RECI = *BLANKS
     C                   EVAL      S1BRCH = *BLANKS
     C                   EVAL      S1TYPE = *BLANKS
     C                   EVAL      S1STPE = *BLANKS
     C                   EVAL      S1CUSN = *BLANKS
     C                   EVAL      S1CURR = *BLANKS
     C                   EVAL      S1PMLI = *BLANKS
     C                   EVAL      S1RPNM = *BLANKS
     C                   EVAL      S1RPTN = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Transfer Records from SDRPIFPD to Subfile            *
      *                                                               *
      *****************************************************************
     C     SRMove        BEGSR
 
     C                   IF        RPRECI = '*'
     C                   EVAL      S1RECI = RPRECI
     C                   ENDIF
 
     C                   EVAL      S1BRCH = RPBRCH
     C                   EVAL      S1TYPE = RPTYPE
     C                   EVAL      S1STPE = RPSTPE
     C                   EVAL      S1CUSN = RPCUSN
     C                   EVAL      S1CURR = RPCURR
     C                   EVAL      S1PMLI = RPPMLI
 
     C                   IF        S1CUSN <> *BLANKS
     C                   EVAL      PCUST = S1CUSN
     C                   EXSR      SrGetCusDtl
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S1RPNM = BBCRNM
     C                   EVAL      S1RPTN = BBCRTN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create/Amend/Delete Records                         *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
 
      ** Clear error flag
 
     C                   EVAL      WriteErr = *BLANKS
 
      ** Insert new record
 
     C                   IF        *IN09 = *ON
     C                   EXSR      SRMoveToFile
     C                   EVAL      RPTYLC = 'I'
     C                   Z-ADD     BJRDNB        RPLCD
     C                   EVAL      RPTMST = TimeStamp
     C                   EVAL      RPUSER = S1USER
     C                   WRITE     RPIFL1                               61
     C                   ENDIF
 
      ** Amend existing record
 
     C                   IF        S1ACTN = 'A'
     C     REPIKY        CHAIN     SDRPIFL1
     C                   IF        %FOUND
     C                   IF        W1TMST = RPTMST
     C                   EXSR      SRMoveToFile
     C                   EVAL      RPTYLC = 'A'
     C                   Z-ADD     BJRDNB        RPLCD
     C                   EVAL      RPTMST = TimeStamp
     C                   EVAL      RPUSER = S1USER
     C                   UPDATE    RPIFL1                               61
     C                   ELSE
     C                   EVAL      *IN40 = *ON
     C                   EVAL      WriteErr = 'Y'
     C                   EVAL      PZMsgID = 'USR0688'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Delete an existing record
 
     C                   IF        S1ACTN = 'D'
     C     REPIKY        CHAIN     SDRPIFL1
     C                   IF        %FOUND AND
     C                             W1TMST = RPTMST
     C                   EVAL      RPRECI = '*'
     C                   EVAL      RPTYLC = 'D'
     C                   Z-ADD     BJRDNB        RPLCD
     C                   EVAL      RPTMST = TimeStamp
     C                   EVAL      RPUSER = S1USER
     C                   UPDATE    RPIFL1                               61
     C                   ELSE
     C                   EVAL      *IN40 = *ON
     C                   EVAL      WriteErr = 'Y'
     C                   EVAL      PZMsgID = 'USR0688'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Write/update error detected
 
     C                   IF        *IN61 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      WriteErr = 'Y'
     C                   EVAL      PZMsgID = 'USR0677'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      *****************************************************************
     C     SRZasnms      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM      'GBSDUSRMSG'  PZMsgFile
     C                   PARM                    PZMsgID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms2 - Message Handling Subroutine                       *
      *                                                               *
      *****************************************************************
     C     SRZasnms2     BEGSR
 
     C                   CALL      'ZA0350'
     C                   PARM      'GBSDUSRMSG'  PZMsgFile
     C                   PARM                    PZMsgID
     C                   PARM                    PZMsgData
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetScrn2 - Retrieve Detail Screen 1 Details                 *
      *                                                               *
      *****************************************************************
     C     SRGetScrn2    BEGSR
 
      ** Get Branch Details
 
     C                   EVAL      S3BRCH = RPBRCH
 
     C                   IF        S3BRCH = 'ALL'
     C                   EVAL      S3BRDS = 'ALL BRANCHES'
     C                   ELSE
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    RPBRCH
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S3BRDS = A8BRNM
     C                   ENDIF
     C                   ENDIF
 
      ** Get Transaction Type Details
 
     C                   IF        RPTYPE <> *BLANKS
     C                   Z-ADD     1             X
     C                   Z-ADD     1             Y
     C     RPTYPE        LOOKUP    FXDLAr(X)                              13
     C     RPTYPE        LOOKUP    FRAIRSAr(Y)                            14
 
     C                   IF        *IN13 = *ON
     C                   EVAL      S3TYDS = FXDLDes(X)
     C                   ENDIF
 
     C                   IF        *IN14 = *ON
     C                   EVAL      S3TYDS = FRAIRSDes(Y)
     C                   ENDIF
 
     C                   ENDIF
 
      ** Get Transaction Sub-type Details
 
     C                   IF        RPSTPE <> *BLANKS
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    RPSTPE
     C     SDDLST        PARM      SDDLST        DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S3STDS = ASDSTN
     C                   ENDIF
     C                   ENDIF
 
      ** Get Counterparty Details
 
     C                   EVAL      S3CUSN = RPCUSN
     C                   IF        RPCUSN <> *BLANKS
     C                   EVAL      PCUST = RPCUSN
     C                   EXSR      SrGetCusDtl
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S3RPNM = BBCRNM
     C                   EVAL      S3RPTN = BBCRTN
     C                   EVAL      S3SWID = BBCSID
     C                   EVAL      S3LEIC = CSLEIC
     C                   ENDIF
     C                   ENDIF
 
      ** Get Currency Details
 
     C                   EVAL      S3CURR = RPCURR
     C                   IF        RPCURR <> *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    RPCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S3CYDS = A6CYNM
     C                   ENDIF
     C                   ENDIF
 
      ** Get Precious Metal Indicator
 
     C                   EVAL      S3PMLI = RPPMLI
 
      ** Get Trade Repository Details
 
     C                   EVAL      S3TRID = RPTRID
     C                   IF        RPTRID <> *BLANKS
     C                   EVAL      PCUST = RPTRID
     C                   EXSR      SrGetCusDtl
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S3TRNM = BBCRNM
     C                   EVAL      S3TRTN = BBCRTN
     C                   EVAL      S3TRSW = BBCSID
     C                   ENDIF
     C                   ENDIF
 
      ** Get CCP House Details
 
     C                   EVAL      S3CCPN = RPCCPN
     C                   EVAL      S3CCPA = RPCCPA
     C                   IF        RPCCPN <> *BLANKS
     C                   EVAL      PCUST = RPCCPN
     C                   EXSR      SrGetCusDtl
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S3CPNM = BBCRNM
     C                   EVAL      S3CPTN = BBCRTN
     C                   EVAL      S3CPSW = BBCSID
     C                   EVAL      S3CPLC = CSLEIC
     C                   ENDIF
     C                   ENDIF
 
      ** Get Clearing Exception Details
 
     C                   EVAL      S3CCPP = RPCCPP
     C                   EVAL      S3CRPA = RPCRPA
     C                   IF        RPCCPP <> *BLANKS
     C                   EVAL      PCUST = RPCCPP
     C                   EXSR      SrGetCusDtl
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S3CRNM = BBCRNM
     C                   EVAL      S3CRTN = BBCRTN
     C                   EVAL      S3CRSW = BBCSID
     C                   EVAL      S3CRLC = CSLEIC
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      S3CBCL = RPCBCL
     C                   EVAL      S3CCPL = RPCCPL
     C**********         EVAL      S3CPID = RPCPID                                            CSW214
     C**********         EVAL      S3EXVE = RPEXVE                                            CSW214
     C**********         EVAL      S3UPID = RPUPID                                            CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      S3CBRI = RPCBRI                                            CSW214
     C                   EVAL      S3CBRA = RPCBRA                                            CSW214
     C                   IF        RPCBRI <> *BLANKS                                          CSW214
     C                   EVAL      PCUST = RPCBRI                                             CSW214
     C                   EXSR      SrGetCusDtl                                                CSW214
     C                   IF        PRTCD <> *BLANKS                                           CSW214
     C                   EVAL      *IN40 = *ON                                                CSW214
     C                   EVAL      *IN47 = *ON                                                CSW214
     C                   EVAL      W#EROR2 = 'Y'                                              CSW214
     C                   EVAL      PZMsgID = 'USR0157'                                        CSW214
     C                   EXSR      SRZasnms                                                   CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      S3CBNM = BBCRNM                                            CSW214
     C                   EVAL      S3CBTN = BBCRTN                                            CSW214
     C                   EVAL      S3CBSW = BBCSID                                            CSW214
     C                   EVAL      S3CBLC = CSLEIC                                            CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetScrn3 - Retrieve Detail Screen 2 Details                 *
      *                                                               *
      *****************************************************************
     C     SRGetScrn3    BEGSR
 
     C                   EVAL      S4CPID = RPCPID                                            CSW214
     C                   EVAL      S4EXVE = RPEXVE                                            CSW214
     C                   EVAL      S4UPID = RPUPID                                            CSW214
     C                   EVAL      S4RPJN = RPRPJN
     C                   EVAL      S4RPPY = RPRPPY
     C                   EVAL      S4RPAC = RPRPAC
     C                   IF        RPRPPY <> *BLANKS
     C                   EVAL      PCUST = RPRPPY
     C                   EXSR      SRGetCusDtl
     C                   IF        PRTCD = *BLANKS
     C**********         EVAL      S4RPAC = BBCUST                                          MD022158
     C                   EVAL      S4RPNM = BBCRNM
     C                   EVAL      S4RPTN = BBCRTN
     C                   EVAL      S4RPSW = BBCSID
     C                   EVAL      S4RPLC = CSLEIC
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      S4GTID = RPGTID
 
     C                   IF        RPCTAM <> 0
     C                   MOVEL     *BLANKS       ZField
     C                   MOVE      RPCTAM        ZField
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    RPCTCY
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        PRTCD = *BLANKS
     C                   Z-ADD     A6NBDP        ZDecimal
     C                   ENDIF
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZField
     C                   PARM                    ZDecimal
     C                   MOVE      ZField        S4CTAM
     C                   ELSE
     C                   EVAL      S4CTAM = *BLANKS
     C                   ENDIF
 
     C                   EVAL      S4CTCY = RPCTCY
     C                   EVAL      S4ALIN = RPALIN
     C                   EVAL      S4CLIN = RPCLIN
     C                   EVAL      S4NSFL = RPNSFL
     C                   EVAL      S4EXDE = RPEXDE
     C                   EVAL      S4EXTC = RPEXTC
     C**********         EVAL      S4AD01 = RPAD01                                            CSW214
     C**********         EVAL      S4AD02 = RPAD02                                            CSW214
     C**********         EVAL      S4AD03 = RPAD03                                            CSW214
     C**********         EVAL      S4AD04 = RPAD04                                            CSW214
     C**********         EVAL      S4AD05 = RPAD05                                            CSW214
     C**********         EVAL      S4AD06 = RPAD06                                            CSW214
     C**********         EVAL      S4AD07 = RPAD07                                            CSW214
     C**********         EVAL      S4AD08 = RPAD08                                            CSW214
     C**********         EVAL      S4AD09 = RPAD09                                            CSW214
     C**********         EVAL      S4AD10 = RPAD10                                            CSW214
     C**********         EVAL      S4AD11 = RPAD11                                            CSW214
     C**********         EVAL      S4AD12 = RPAD12                                            CSW214
     C**********         EVAL      S4AD13 = RPAD13                                            CSW214
     C**********         EVAL      S4AD14 = RPAD14                                            CSW214
     C**********         EVAL      S4AD15 = RPAD15                                            CSW214
     C**********         EVAL      S4AD16 = RPAD16                                            CSW214
     C**********         EVAL      S4AD17 = RPAD17                                            CSW214
     C**********         EVAL      S4AD18 = RPAD18                                            CSW214
     C**********         EVAL      S4AD19 = RPAD19                                            CSW214
     C**********         EVAL      S4AD20 = RPAD20                                            CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      S4FNCI = RPFNCI                                            CSW214
     C                   EVAL      S4COPI = RPCOPI                                            CSW214
     C                   EVAL      S4COPC = RPCOPC                                            CSW214
     C                   EVAL      S4POCI = RPPOCI                                            CSW214
     C                   EVAL      S4COSI = RPCOSI                                            CSW214
     C                   EVAL      S4TNEI = RPTNEI                                            CSW214
     C                   EVAL      S4IGTI = RPIGTI                                            CSW214
     C                   EVAL      S4CTFI = RPCTFI                                            CSW214
     C                   ENDIF                                                                CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMoveToFile - Move fields from screen to file                *
      *                                                               *
      *****************************************************************
     C     SRMoveToFile  BEGSR
 
     C                   IF        *IN09 = *ON
     C                   EVAL      RPRECI = 'D'
     C                   EVAL      RPBRCH = S2BRCH
     C                   EVAL      RPTYPE = S2TYPE
     C                   EVAL      RPSTPE = S2STPE
     C                   EVAL      RPCUSN = S2CUSN
     C                   EVAL      RPCURR = S2CURR
     C                   EVAL      RPPMLI = S2PMLI
     C                   ENDIF
 
     C                   EVAL      RPTRID = S3TRID
     C                   EVAL      RPCCPN = S3CCPN
     C                   EVAL      RPCCPA = S3CCPA
     C                   EVAL      RPCCPP = S3CCPP
     C                   EVAL      RPCRPA = S3CRPA
     C                   EVAL      RPCBCL = S3CBCL
     C                   EVAL      RPCCPL = S3CCPL
     C**********         EVAL      RPCPID = S3CPID                                            CSW214
     C**********         EVAL      RPEXVE = S3EXVE                                            CSW214
     C**********         EVAL      RPUPID = S3UPID                                            CSW214
     C                   EVAL      RPCPID = S4CPID                                            CSW214
     C                   EVAL      RPEXVE = S4EXVE                                            CSW214
     C                   EVAL      RPUPID = S4UPID                                            CSW214
     C                   EVAL      RPRPJN = S4RPJN
     C                   EVAL      RPRPPY = S4RPPY
     C                   EVAL      RPRPAC = S4RPAC
     C                   EVAL      RPGTID = S4GTID
     C                   IF        S4CTAM <> *BLANKS
     C                   MOVE      AMNT          RPCTAM
     C                   ELSE
     C                   EVAL      RPCTAM = 0
     C                   ENDIF
     C                   EVAL      RPCTCY = S4CTCY
     C                   EVAL      RPALIN = S4ALIN
     C                   EVAL      RPCLIN = S4CLIN
     C                   EVAL      RPNSFL = S4NSFL
     C                   EVAL      RPEXDE = S4EXDE
     C                   EVAL      RPEXTC = S4EXTC
     C**********         EVAL      RPAD01 = S4AD01                                            CSW214
     C**********         EVAL      RPAD02 = S4AD02                                            CSW214
     C**********         EVAL      RPAD03 = S4AD03                                            CSW214
     C**********         EVAL      RPAD04 = S4AD04                                            CSW214
     C**********         EVAL      RPAD05 = S4AD05                                            CSW214
     C**********         EVAL      RPAD06 = S4AD06                                            CSW214
     C**********         EVAL      RPAD07 = S4AD07                                            CSW214
     C**********         EVAL      RPAD08 = S4AD08                                            CSW214
     C**********         EVAL      RPAD09 = S4AD09                                            CSW214
     C**********         EVAL      RPAD10 = S4AD10                                            CSW214
     C**********         EVAL      RPAD11 = S4AD11                                            CSW214
     C**********         EVAL      RPAD12 = S4AD12                                            CSW214
     C**********         EVAL      RPAD13 = S4AD13                                            CSW214
     C**********         EVAL      RPAD14 = S4AD14                                            CSW214
     C**********         EVAL      RPAD15 = S4AD15                                            CSW214
     C**********         EVAL      RPAD16 = S4AD16                                            CSW214
     C**********         EVAL      RPAD17 = S4AD17                                            CSW214
     C**********         EVAL      RPAD18 = S4AD18                                            CSW214
     C**********         EVAL      RPAD19 = S4AD19                                            CSW214
     C**********         EVAL      RPAD20 = S4AD20                                            CSW214
     C                   EVAL      RPAD01 = S7AD01                                            CSW214
     C                   EVAL      RPAD02 = S7AD02                                            CSW214
     C                   EVAL      RPAD03 = S7AD03                                            CSW214
     C                   EVAL      RPAD04 = S7AD04                                            CSW214
     C                   EVAL      RPAD05 = S7AD05                                            CSW214
     C                   EVAL      RPAD06 = S7AD06                                            CSW214
     C                   EVAL      RPAD07 = S7AD07                                            CSW214
     C                   EVAL      RPAD08 = S7AD08                                            CSW214
     C                   EVAL      RPAD09 = S7AD09                                            CSW214
     C                   EVAL      RPAD10 = S7AD10                                            CSW214
     C                   EVAL      RPAD11 = S7AD11                                            CSW214
     C                   EVAL      RPAD12 = S7AD12                                            CSW214
     C                   EVAL      RPAD13 = S7AD13                                            CSW214
     C                   EVAL      RPAD14 = S7AD14                                            CSW214
     C                   EVAL      RPAD15 = S7AD15                                            CSW214
     C                   EVAL      RPAD16 = S7AD16                                            CSW214
     C                   EVAL      RPAD17 = S7AD17                                            CSW214
     C                   EVAL      RPAD18 = S7AD18                                            CSW214
     C                   EVAL      RPAD19 = S7AD19                                            CSW214
     C                   EVAL      RPAD20 = S7AD20                                            CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      RPCBRI = S3CBRI                                            CSW214
     C                   EVAL      RPCBRA = S3CBRA                                            CSW214
     C                   EVAL      RPFNCI = S4FNCI                                            CSW214
     C                   EVAL      RPCOPI = S4COPI                                            CSW214
     C                   EVAL      RPCOPC = S4COPC                                            CSW214
     C                   EVAL      RPPOCI = S4POCI                                            CSW214
     C                   EVAL      RPCOSI = S4COSI                                            CSW214
     C                   EVAL      RPTNEI = S4TNEI                                            CSW214
     C                   EVAL      RPIGTI = S4IGTI                                            CSW214
     C                   EVAL      RPCTFI = S4CTFI                                            CSW214
     C                   ENDIF                                                                CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetCusDtl - Get Customer Details                            *
      *                                                               *
      *****************************************************************
     C     SRGetCusDtl   BEGSR
 
     C                   CLEAR                   DSLDY
 
     C                   CALL      'AOCSSWR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    PCUST
     C                   PARM                    PKYST
     C                   PARM                    DSLDY
 
     C                   EVAL      WStr = %LEN(SDCUST) + 1
     C                   EVAL      WLen = %LEN(SDCSSW)
     C                   EVAL      SDCUST = DSLDY
     C                   EVAL      SDCSSW = %SUBST(DSLDY:WStr:WLen)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkXSet - Check for valid SWIFT characters (X-Set)          *
      *                                                               *
      *****************************************************************
     C     SRChkXSet     BEGSR
 
     C                   EVAL      *IN99 = *OFF
     C     ISO           CHECK     FldChk                                 99
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCodeWord - Check for valid codewords                        *
      *                                                               *
      *****************************************************************
     C     SRCodeWord    BEGSR
 
     C                   EVAL      CodeWordOK = *BLANKS
 
      ** First character must be '/'
 
     C                   MOVEL     CWordChk      WSlash
     C                   IF        WSlash <> '/'
     C                   EVAL      CodeWordOK = 'N'
     C                   ENDIF
 
      ** Codeword must end with '/'
 
     C     '/'           SCAN      CWordChk:2    WSlash2
     C                   IF        NOT %FOUND
     C                   EVAL      CodeWordOK = 'N'
     C                   ENDIF
 
      ** Codeword should be 8 characters or fewer
 
     C                   IF        WSlash2 > 10
     C                   EVAL      CodeWordOK = 'N'
     C                   ENDIF
 
      ** First line must not start with '//'
 
     C                   IF        Line1 = 'Y' AND
     C                             WSlash2 = 2
     C                   EVAL      CodeWordOK = 'N'
     C                   ENDIF
     C                   EVAL      Line1 = *BLANKS
 
      ** Check for valid codewords
 
     C                   IF        CodeWordOK <> 'N'
     C     Alpha         CHECK     CWordChk:2    CharPos                  99
     C                   IF        *IN99 = *ON AND
     C                             CharPos < WSlash2
     C                   EVAL      CodeWordOK = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        CodeWordOK = 'N'                                        MD023614A
     C                   EVAL      CodeWordCnt += 1                                        MD023614A
     C                   ENDIF                                                             MD023614A
                                                                                           MD023614A
     C                   EVAL      SlashOK = *BLANKS
     C                   MOVEL     CWordChk      SlashChk
     C                   IF        SlashChk <> '//'
     C                   EVAL      SlashOK = 'N'
     C                   EVAL      SlashCnt += 1                                           MD023614A
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkActn - Check for allowed action codes for user           *
      *                                                               *
      *****************************************************************
     C     SRChkActn     BEGSR
 
     C                   CALL      'ZVRAT'
     C                   PARM                    DBRN
     C                   PARM                    ZAction
     C                   PARM                    ZError
 
     C                   IF        ZError = 0 AND
     C                             ZAction <> *BLANKS
     C                   MOVEA     ZAction       ActnCdAr
     C                   ENDIF
 
     C     'A'           LOOKUP    ActnCdAr                               16
     C     'D'           LOOKUP    ActnCdAr                               17
     C     'E'           LOOKUP    ActnCdAr                               18
     C     'I'           LOOKUP    ActnCdAr                               19
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkSel - Check if selection is performed on a field         *
      *                                                               *
      *****************************************************************
     C     SRChkSel      BEGSR
 
     C                   IF        WSelFld = '?'
     C                   EVAL      WSEL = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** If selection mode and F3 has been pressed
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Retrieve entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PMODE
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD000111'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
      ** Call Access Program for Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'SD000111'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call Access Program for Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'SD000111'
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call access program for system values
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      SVAL1         P@OP01           20
     C                   PARM      *BLANKS       P@VL01          200
     C                   PARM      SVAL2         P@OP02           20
     C                   PARM      *BLANKS       P@VL02          200
     C                   PARM      *BLANKS       P@OP03           20
     C                   PARM      *BLANKS       P@VL03          200
     C                   PARM      *BLANKS       P@OP04           20
     C                   PARM      *BLANKS       P@VL04          200
     C                   PARM      *BLANKS       P@OP05           20
     C                   PARM      *BLANKS       P@VL05          200
     C                   PARM      *BLANKS       P@OP06           20
     C                   PARM      *BLANKS       P@VL06          200
     C                   PARM      *BLANKS       P@OP07           20
     C                   PARM      *BLANKS       P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM      *BLANKS       P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM      *BLANKS       P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM      *BLANKS       P@VL10          200
 
     C                   EVAL      CtpyNonSwift = P@VL01
     C                   EVAL      CtpySwift = P@VL02
 
     C                   Z-ADD     14            WSFPG
 
      ** Initialise subfile control
 
     C                   EVAL      #1PGMQ = PSProcName
     C                   EVAL      S1WSID = PSJobName
     C                   EVAL      S1USER = PSUser
 
     C                   EVAL      SEBRCH = *BLANKS
     C                   EVAL      SETYPE = *BLANKS
     C                   EVAL      SESTPE = *BLANKS
     C                   EVAL      SECUSN = *BLANKS
     C                   EVAL      SECURR = *BLANKS
     C                   EVAL      SEPMLI = *BLANKS
 
      ** Check if SWIFT Changes 2014 is installed                                             CSW214
                                                                                              CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD                                        CSW214
                                                                                              CSW214
     C                   IF        PRTCD = 'CSW2014'                                          CSW214
     C                   EVAL      CSW214 = 'Y'                                               CSW214
     C                   EVAL      *IN98 = *ON                                                CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CSW214 = 'N'                                               CSW214
     C                   EVAL      *IN98 = *OFF                                               CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
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
      /EJECT
      *****************************************************************
      ** Add CLCLS in FXDLAr                                                                MD021546
** FXDLAr
FXALL FX TRANSACTION TYPES
FPPURCHASE
FSSALE
CXCROSS DEAL
PIPURCHASE COVERING INTEREST
SISALE COVERING INTEREST
OPOPTION
OTOPTION TAKE DOWN
SWSWAP
CLCLS
** FRAIRSAr
FRFORWARD RATE AGREEMENT
RSINTEREST RATE SWAP - SINGLE CURRENCY
RXINTEREST RATE SWAP - CROSS - CURRENCY
RPINTEREST RATE CAP
RRINTEREST RATE COLLAR
RFINTEREST RATE FLOOR
