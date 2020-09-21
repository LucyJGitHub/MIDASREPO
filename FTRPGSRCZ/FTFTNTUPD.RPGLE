     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Update')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTFTNTUPD - Midas FT Nostro Transfer Database Update         *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CFT163             Date 04May18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD034756           Date 11Aug15               *
      *                 MD032097           Date 28Jan15               *
      *                 CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CFT163 - FT Nostro Transfer Authorisation (RPG)              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034756 - Create Projected movements during Amend/Reject    *
      *  MD032097 - Incorrect calculation of NTRANZZ                  *
      *  CAP212 - FT Nostro Transfer API                              *
      *                                                               *
      *****************************************************************

     FNTRAN     UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      * Nostro Transfers Details File

     FNTRANZZ   UF   E             DISK    COMMIT
     F                                     INFSR(*PSSR)
      * Nostro Transfers Trailer File

     FSDCWHTL1  IF   E           K DISK

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------

      **------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Rename fields for Timestamp checking
     D ChkNoTrFmt    E DS                  EXTNAME(NTRANDD)
     D                                     PREFIX(CH)
     D  CHIntBnk             380    554

      ** Externally desc'd DS for valid transactions Detail
     D FTVNoTr       E DS                  EXTNAME(FTVFTNTPD)
     D                                     PREFIX(A_)
     D  ValidDS1               1     22
     D  ValidDS2              28     46
     D  ValidDS3              75    218
     D  ValidDS4             224    257
     D  ValidDS5             263    281
     D  ValidDS6             295    357
     D  ValidDS7             361    626
     D  ValidIntBnk          406    580

      * Error indicators
     D OKTrnDets     E DS                  EXTNAME(FTEFTNTPD)

      **  Transaction Details File
     D NoTrF         E DS                  EXTNAME(NTRANDD)
     D  NtranDS1               1     22
     D  NtranDS2              26     44
     D  NtranDS3              60    203
     D  NtranDS4             207    240
     D  NtranDS5             244    262
     D  NtranDS6             270    332
     D  NtranDS7             335    574

      * Data Structures for use with access programs

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * Data structure for customer details

     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
      * Midas SD Watch List Configuration Data File

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * Data structure for SAR details
     D  SCLCD        E                     EXTFLD(LCD)

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      * Data structure for SDSTAT

     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)
      * Data Structure for Watch List Checking Details

     D PSDWLT        E DS                  EXTNAME(SDWLTOPD)
      * Watch List Transaction details file

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      * 24X7 Data Structure

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure

     D NTFRFD          DS             4
     D  NTFRF                  1      4  0

     D C#DTA           DS           256
     D  C#ATYP                 1      1
     D  QQACCT                 2     19
     D  C#CNU1                 2      7
     D  C#CCY1                 8     10
     D  QQACO1                11     14  0
     D  C#ACS1                15     16  0
     D  C#BRC1                17     19
     D  C#NOSN                 2      3  0
     D  C#NOS                  2      6
     D  C#ACNO                 2     11  0
     D  C#CNUM                 2      7
     D  QQACOD                 8     11  0
     D  C#ACSQ                12     13  0
     D  C#BRCA                14     16
     D  C#IO                  24     24
     D  C#CCY                 25     27
     D  C#TRYP                28     29
     D  C#NARR                30     59
     D  C#CHQN                60     67  0
     D  C#PREF                68     82
     D  C#TRN                 83     88
     D  C#AMT                 89     96P 0
     D  C#PRON                97     97
     D  C#OLPS                98     98
     D  C#MEMS                99     99
     D  C#RSAC               100    100
     D  C#MOD                101    102
     D  C#OLRC               103    104
     D  C#FTOV               105    105
     D  C#VDAT               106    108P 0
     D  C#PSTD               109    111P 0
     D  C#PSTO               112    112
     D  C#RPST               113    113
     D  C#RPNB               114    116  0
     D  C#RTYP               117    117
     D  C#ACO1               121    130  0
     D  C#ACOD               131    140  0
     D  C#OTR1               141    160
     D  C#MTYP               161    161
     D  C#XRFI               162    164
     D  C#XRFN               165    174  0

     D                 DS
     D  C#ACCT                 1     24
     D  W#ACNO                 1     10  0
     D  W#NOS                  1      5
     D  W#NOSN                 1      2  0
     D  W#CNU1                 1      6
     D  W#CCY1                 7      9
     D  W#ACOD                 7     16  0
     D  W#ACSQ                17     18  0
     D  W#ACO1                10     19  0
     D  W#ACS1                20     21  0
     D  W#BRC1                22     24

     D C#CNTL          DS           256
     D C#PDTI                  1      1
     D C#CCYI                  2      3
     D C#GLUI                  4      4
     D C#TPCI                  5      5

     D PXML            DS          9999

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0

     D ##FTOV          S              1
     D K3FUNT          S              8
     D K3IDEN          S             40
     D K3BRCH          S              3
     D WAACBN          S              2  0
     D WACBNX          S              1
     D WADEST          S              2  0
     D WDESTX          S              1
     D WATCH           S              1
     D WCTYP           S              1
     D WINBXX          S              1
     D WKFLD4          S              4
     D WKFLD8          S              8
     D WKTFRF          S              7
     D WRNRT           S             30

     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PFUNC           S              8
     D PMOD            S              2
     D PTREF           S             15
     D PRTINF          S             80
     D PKEY1           S             10
     D PKYST           S              7
     D O#DTA           S            256

     D PINP1           S             35
     D PINP2           S             35
     D PINP3           S             35
     D PINP4           S             35
     D PINP5           S             35
     D PINP6           S             35
     D PCCY            S              3
     D POUT            S            216
     D POUT2           S              6

     D CSC011          S              1
     D CCF001          S              1
     D CSD015          S              1
     D CRE020          S              1
     D CAP205          S              1
     D CFT163          S              1A                                                      CFT163

     D MidasTrRef      S             15
     D @Return         S              6
     D @Type           S              1
     D @@MODE          S              6
     D @@RSMD          S              1
     D ACTN            S              1
     D FOTRID          S             20
     D DDACTNOK        S              1
     D DDTFRFOK        S              1
     D C               S              2  0
     D DBError         S            132
     D MsgSndRtn       S             10
     D WTFRF           S              4  0
     D TIME            S              6  0

     D WDATE1          S              6  0
     D WDATE2          S              2  0
     D WDATE3          S              6  0
     D WDATE4          S              4  0
     D WDATE5          S              2  0
     D WDATE6          S              2  0
     D WRVAST          S              1
     D W0ACT           S              8

     D ZZAMT           S             15  3
     D ZZAMT1          S             15  3
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZWK2           S              4  0
     D ZZWK3           S             15  0
     D ZZNEGD          S              5

      ** Watch list description arrays
     D OPTAG           S             25    DIM(3) CTDATA PERRCD(1)
     D CLTAG           S             25    DIM(3) CTDATA PERRCD(1)

     D/COPY ZSRSRC,ZDATE2Z1LE
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************

      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD

     C                   IF        ReturnCode <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF

     C                   TIME                    TIME

      ** Insert, Amend or Delete the transaction
     C     A_NVCHTP      CASEQ     'I'           INSERT
     C     A_NVCHTP      CASEQ     'A'           AMEND
     C     A_NVCHTP      CASEQ     'D'           DELETE
     C                   ENDCS

      ** Call CL program to deallocate reference to a dataarea
     C                   CALL      'AOC8000'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      'FT'          PMOD
     C                   PARM      *BLANKS       PTREF
     C                   PARM      *BLANKS       PRTINF

      * Exit From Program
     C     EXIT          TAG

     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      **  Program Parameters
     C     *ENTRY        PLIST

      ** Return Code
     C                   PARM                    ReturnCode

      ** Externally described DS for valid Transaction Detail
     C                   PARM                    FTVNoTr
      *
      ** Access Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'                          *************
     C                   EVAL      DBASE  = 909                                 * DBERR 909 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      *
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF

      ** Determine if CSC011 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVE      'Y'           CSC011
     C                   IN        SC24X7
     C                   ELSE
     C                   MOVE      'N'           CSC011
     C                   ENDIF

      ** Determine if CCF001 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CCF011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVE      'Y'           CCF001
     C                   ELSE
     C                   MOVE      'N'           CCF001
     C                   ENDIF

      ** Determine if CSD015 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD015'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVE      'Y'           CSD015
     C                   ELSE
     C                   MOVE      'N'           CSD015
     C                   ENDIF

      ** Determine if CRE020 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE020'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVE      'Y'           CRE020
     C                   ELSE
     C                   MOVE      'N'           CRE020
     C                   ENDIF

      ** Determine if CAP205 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAP205'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVE      'Y'           CAP205
     C                   ELSE
     C                   MOVE      'N'           CAP205
     C                   ENDIF

      ** If CSD015 is ON, check if function code 'FTNOSTRF' is ON.
     C                   IF        CSD015 = 'Y'
      *
     C                   CALL      'AOWLCCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      'FTNOSTRF'    PFUNC
     C     SDWLCC        PARM      SDWLCC        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDWLCCPD'
     C                   EVAL      DBASE = 908
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDCWCD        PARM      SDCWCD        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDCWCDPD'
     C                   EVAL      DBASE = 907
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF

     C                   IN        SDSTAT

      ** Access FT Control Data
     C                   CALL      'FT0005'
     C                   PARM      *BLANKS       PRTCD
     C     C#CNTL        PARM                    O#DTA
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = 'FT0005'
     C                   EVAL      DBFILE = '*CALL   '
     C                   EVAL      DBASE = 906
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        C#GLUI = 'I'
     C                   EVAL      ##FTOV = 'Y'
     C                   ELSE
     C                   EVAL      ##FTOV = *BLANKS
     C                   ENDIF
      *                                                                                       CFT163
     C                   CALLB     'AOSARDR0'                                                 CFT163
     C                   PARM      *BLANKS       PRTCD                                        CFT163
     C                   PARM      '*VERIFY'     POPTN                                        CFT163
     C                   PARM      'CFT163'      PSARD                                        CFT163
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT163
                                                                                              CFT163
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CFT163
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT163
     C                   EVAL      DBKEY  = 'CFT163'                                          CFT163
     C                   EVAL      DBASE  = 42                                                CFT163
     C                   EXSR      *PSSR                                                      CFT163
     C                   ENDIF                                                                CFT163
                                                                                              CFT163
     C                   IF        PRTCD = *BLANKS                                            CFT163
     C                   EVAL      CFT163 = 'Y'                                               CFT163
     C                   ELSE                                                                 CFT163
     C                   EVAL      CFT163 = 'N'                                               CFT163
     C                   ENDIF                                                                CFT163
      *                                                                                       CFT163
     C     KCWHT         KLIST
     C                   KFLD                    K3FUNT
     C                   KFLD                    K3IDEN
     C                   KFLD                    K3BRCH

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR

      ** Retrieve current Nostro Transfer Details
     C                   MOVE      A_NVTFRF      MidasTrRef

      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return
     C                   PARM                    @Type
      *
      ** Allow access to transaction record by Front-Office ID when in Repair
      ** mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT
      ** if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~
      **                 b) action code is Insert - 'I'
      **                 c) Front-Office Id is NOT Blank
     C                   IF        @Type = '1' AND
     C                             A_NVCHTP = 'I' AND
     C                             A_NVFRNT <> *BLANKS
      *
     C                   EVAL      @@MODE = '*FRONT'
      *
     C                   ELSE
      *
      ** Otherwise, if running in batch use Front-Office ID
      **            (if insert)
      **            else, use Midas Deal Number
     C                   IF        @Type = '0' AND
     C                             A_NVCHTP = 'I'
     C                   EVAL      @@MODE = '*FRONT'
     C                   ELSE
     C                   EVAL      @@MODE = *BLANKS
     C                   ENDIF
      *
     C                   ENDIF

     C                   CALLB     'FTFTNTRTV'
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE
      *
      * Response mode
     C                   PARM      'S'           @@RSMD
      *
      * Action Code
     C                   PARM      A_NVCHTP      ACTN
      *
      * Front Office Transaction ID
     C                   PARM      A_NVFRNT      FOTRID
      *
      * Midas Transfer Reference
     C                   PARM                    MidasTrRef
      *
      * Outputs
      *
      * Transaction Details in File Format
     C                   PARM                    ChkNoTrFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      * OK - Transfer Reference
     C                   PARM                    DDTFRFOK

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)

      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Customer was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.

      ** Interactive mode:
     C                   IF        @TYPE = '1'

     C                   IF        CHTMST <> A_NVTMST OR
     C                             A_NVCHTP = 'A' AND
     C                             CHAUIN = 'Y' OR
     C                             A_NVCHTP = 'D' AND
     C                             CHAUIN = 'Y'
     C                   EVAL      ReturnCode = '*RECUPD'
     C                   ENDIF

      ** Batch mode:
     C                   ELSE
     C                   IF        DDACTNOK = 'N' OR
     C                             DDTFRFOK = 'N'
     C                   EVAL      ReturnCode = '*RECUPD'
     C                   Z-ADD     1             C

     C                   DOW       C <= ArrayMax AND
     C                             FldNameArr(C) <> *BLANKS
     C                   CLEAR                   DBError
     C                   EVAL      DBerror = 'Update error: ' + FOTRID
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * INSERT - Insert a transaction                                *
      *                                                              *
      ****************************************************************
     C     INSERT        BEGSR

      ** Check if Watch List Checking Engine needs to be called
     C                   EVAL      WATCH = 'N'
     C                   IF        CSD015 = 'Y' AND
     C                             W1EWLC = 'Y'
      *
     C                   IF        CSC011 = 'N' OR
     C                             CSC011 = 'Y' AND
     C                             LIBR = S1MAIN
     C                   EXSR      SRCHCK
     C                   ENDIF
      *
     C                   ENDIF

      ** Clear stored values
     C                   EXSR      SRCLR

      ** Obtain next transfer reference sequence number
     C     *DTAARA       DEFINE    NTRANDA       NTFRFD
     C     *LOCK         IN        NTFRFD
     C                   Z-ADD     NTFRF         WTFRF
     C                   ADD       1             NTFRF
     C                   OUT       NTFRFD

     C                   Z-ADD     BJRDNB        A_NVOEDT
     C                   Z-ADD     A_NVOEDT      ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         A_NVOED1
     C                   MOVE      A_NVOED1      WDATE1
     C                   EXSR      DAFDT
     C                   MOVE      WDATE2        A_NVOED2
     C                   MOVE      WDATE3        A_NVOED3

      ** Set-up new transfer reference
     C                   MOVEL     *BLANKS       A_NVTFRF
     C                   MOVEL     'P'           WKTFRF
     C                   MOVE      A_NVOED3      WKTFRF
     C                   MOVEL     WKTFRF        A_NVTFRF
     C                   MOVEL     'NT'          WKFLD4
     C                   MOVE      A_NVSTMT      WKFLD4
     C                   MOVE      WKFLD4        WKFLD8
     C                   MOVEL     WTFRF         WKFLD8
     C                   MOVE      WKFLD8        A_NVTFRF

      ** Access Transaction Details
     C     A_NVTFRF      CHAIN     NTRAN

      ** Database error
     C                   IF        %FOUND
     C                   EVAL      DBKEY  = A_NVTFRF
     C                   EVAL      DBFILE = 'NTRANDD   '                        ************
     C                   EVAL      DBASE  = 001                                 * DBERR 001*
     C                   EXSR      *PSSR                                        ************
     C                   ENDIF

      ** Initialise Transaction Detail
     C                   CLEAR                   NoTrF

      ** Set Transaction fields on insert
     C                   EVAL      NtranDS1 = ValidDS1
     C                   Z-ADD     A_NVVDAT      VDAT
     C                   EVAL      NtranDS2 = ValidDS2
     C                   Z-ADD     A_NVAMNT      AMNT
     C                   Z-ADD     A_NVAMTD      AMNTD
     C                   EVAL      NtranDS3 = ValidDS3
     C                   Z-ADD     A_NVLCD       LCD
     C                   EVAL      NtranDS4 = ValidDS4
     C                   Z-ADD     A_NVOEDT      OEDT
     C                   EVAL      NtranDS5 = ValidDS5
     C                   Z-ADD     A_NVSBCQ      SBCQ
     C                   EVAL      NtranDS6 = ValidDS6
     C                   Z-ADD     A_NVSWSN      SWSN
     C                   EVAL      NtranDS7 = ValidDS7

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   EVAL      TMST  = TimeStamp
     C                   EVAL      A_NVTMST  = TimeStamp

     C                   EVAL      PYTP = 'NT'
     C                   EVAL      LCHT = TIME
     C                   Z-ADD     BJRDNB        LCD
     C                   EVAL      INUSR1 = A_NVINU1

      ** Call watch list checking engine program
     C                   IF        WATCH = 'Y'
     C                   EXSR      SRWTCH
     C                   ENDIF

      ** Write new Transaction Detail
     C                   WRITE     NTRANDDF

      ** Call CL program to allocate this reference to a dataarea
     C                   CALL      'AOC8000'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      'FT'          PMOD
     C                   PARM      TFRF          PTREF
     C                   PARM      *BLANKS       PRTINF

      ** Process shadow post
     C                   Z-ADD     AMNT          ##AMNT
     C                   EXSR      SRADD

      ** Update database with changes
     C                   EXSR      SRUPD

      ** Update trailer file
     C                   EXSR      UTRLR

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * AMEND  - Amend a transaction                                 *
      *                                                              *
      ****************************************************************
     C     AMEND         BEGSR

      ** Check if Watch List Checking Engine needs to be called
     C                   EVAL      WATCH = 'N'
     C                   IF        CSD015 = 'Y' AND
     C                             W1EWLC = 'Y'
      *
     C                   IF        CSC011 = 'N' OR
     C                             CSC011 = 'Y' AND
     C                             LIBR = S1MAIN
     C                   EXSR      SRCHCK
     C                   ENDIF
      *
     C                   ENDIF

      ** Clear stored values
     C                   EXSR      SRCLR

      ** Access Transaction Detail record
     C     A_NVTFRF      CHAIN     NTRAN

      ** Database error
     C                   IF        NOT %FOUND
     C                   EVAL      DBKEY  = A_NVTFRF
     C                   EVAL      DBFILE = 'NTRANDD   '                        ************
     C                   EVAL      DBASE  = 002                                 * DBERR 002*
     C                   EXSR      *PSSR                                        ************
     C                   ENDIF

      ***Set*Transaction*Detail*fields*on*amend*                                            MD034756
     C**********         EVAL      NtranDS1 = ValidDS1                                      MD034756
     C**********         Z-ADD     A_NVVDAT      VDAT                                       MD034756
     C**********         EVAL      NtranDS2 = ValidDS2                                      MD034756
     C**********         Z-ADD     A_NVAMNT      AMNT                                       MD034756
     C**********         Z-ADD     A_NVAMTD      AMNTD                                      MD034756
     C**********         EVAL      NtranDS3 = ValidDS3                                      MD034756
     C**********         Z-ADD     A_NVLCD       LCD                                        MD034756
     C**********         EVAL      NtranDS4 = ValidDS4                                      MD034756
     C**********         Z-ADD     A_NVOEDT      OEDT                                       MD034756
     C**********         EVAL      NtranDS5 = ValidDS5                                      MD034756
     C**********         Z-ADD     A_NVSBCQ      SBCQ                                       MD034756
     C**********         EVAL      NtranDS6 = ValidDS6                                      MD034756
     C**********         Z-ADD     A_NVSWSN      SWSN                                       MD034756
     C**********         EVAL      NtranDS7 = ValidDS7                                      MD034756

      ** Process shadow post (reverse out original entries)
     C                   Z-SUB     AMNT          ##AMNT
     C                   IF        CRE020 = 'Y'
     C                   EVAL      WRVAST = 'Y'
     C                   ENDIF
     C                   EXSR      SRADD

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST = TimeStamp
     C                   EVAL      A_NVTMST  = TimeStamp

      ** Update fields
     C                   EVAL      LCHT = TIME
     C                   Z-ADD     BJRDNB        LCD
     C                   EVAL      INUSR1 = A_NVINU1
     C                   IF        CHOEDT = BJRDNB
     C                   EVAL      CHTP = CHCHTP
     C                   ENDIF

      ** Call watch list checking engine program
     C                   IF        WATCH = 'Y'
     C                   EXSR      SRWTCH
     C                   ENDIF

      ** Set Transaction Detail fields on amend                                             MD034756
     C                   EVAL      NtranDS1 = ValidDS1                                      MD034756
     C                   Z-ADD     A_NVVDAT      VDAT                                       MD034756
     C                   EVAL      NtranDS2 = ValidDS2                                      MD034756
     C                   Z-ADD     A_NVAMNT      AMNT                                       MD034756
     C                   Z-ADD     A_NVAMTD      AMNTD                                      MD034756
     C                   EVAL      NtranDS3 = ValidDS3                                      MD034756
     C                   Z-ADD     A_NVLCD       LCD                                        MD034756
     C                   EVAL      NtranDS4 = ValidDS4                                      MD034756
     C                   Z-ADD     A_NVOEDT      OEDT                                       MD034756
     C                   EVAL      NtranDS5 = ValidDS5                                      MD034756
     C                   Z-ADD     A_NVSBCQ      SBCQ                                       MD034756
     C                   EVAL      NtranDS6 = ValidDS6                                      MD034756
     C                   Z-ADD     A_NVSWSN      SWSN                                       MD034756
     C                   EVAL      NtranDS7 = ValidDS7                                      MD034756
      *                                                                                       CFT163
      ** When CFT163 Enhancement is installed                                                 CFT163
      * Reset of field AUP1 only if CFT163 and A_NVAUIN not equal to 'Y'                      CFT163
      *                                                                                       CFT163
     C     CFT163        IFNE      'Y'                                                        CFT163
     C     A_NVAUIN      ANDNE     'Y'                                                        CFT163
      *                                                                                       CFT163
      ** Reset authorizing profile                                                            CFT163
      *                                                                                       CFT163
     C                   MOVE      *Blanks       AUP1                                         CFT163
                                                                                              CFT163
     C                   ENDIF                                                                CFT163
                                                                                              CFT163
     C                   UPDATE    NTRANDDF

      ** Process shadow post
     C                   Z-ADD     AMNT          ##AMNT
     C                   EXSR      SRADD

      ** Update database with changes
     C                   EXSR      SRUPD

      ** Update trailer file
     C                   EXSR      UTRLR

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * DELETE - Delete a transaction                                *
      *                                                              *
      ****************************************************************
     C     DELETE        BEGSR

      ** Clear stored values
     C                   EXSR      SRCLR

      ** Access Transaction Details
     C     A_NVTFRF      CHAIN     NTRAN

      ** Database error
     C                   IF        NOT %FOUND
     C                   EVAL      DBKEY  = A_NVTFRF
     C                   EVAL      DBFILE = 'NTRANDD   '                        ************
     C                   EVAL      DBASE  = 003                                 * DBERR 003*
     C                   EXSR      *PSSR                                        ************
     C                   ENDIF

      ** Process shadow post (reverse out original entries)
     C                   Z-SUB     AMNT          ##AMNT
     C                   IF        CRE020 = 'Y'
     C                   MOVE      'Y'           WRVAST
     C                   ENDIF
     C                   EXSR      SRADD

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST = TimeStamp
     C                   EVAL      A_NVTMST  = TimeStamp

      ** Change record details
     C                   EVAL      RECI = 'C'
     C                   EVAL      LCHT = TIME
     C                   Z-ADD     BJRDNB        LCD
     C                   EVAL      INUSR1 = A_NVINU1

     C                   UPDATE    NTRANDDF

      ** Update database with changes
     C                   EXSR      SRUPD

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRCHCK  - Check if Watch List Checking Engine Program needs  *
      *           to be called                                       *
      *                                                              *
      ****************************************************************
     C     SRCHCK        BEGSR

     C                   EVAL      W3UNCF = 'N'
     C                   EVAL      WDESTX = 'N'
     C                   EVAL      WACBNX = 'N'
     C                   EVAL      WINBXX = 'N'

     C                   IF        A_NVCHTP = 'A'
     C                   EVAL      K3FUNT = 'NTRANDD '
     C                   EVAL      K3IDEN = CHTFRF
     C                   EVAL      K3BRCH = CHBRCA
     C     KCWHT         CHAIN     SDCWHTL1
     C                   ENDIF

     C                   IF        A_NVDEST <> 0
     C                   EVAL      WADEST = CHDEST
     C                   IF        W3UNCF = 'Y' OR
     C                             A_NVDEST <> WADEST
     C                   EVAL      WDESTX = 'Y'
     C                   EVAL      WATCH = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        A_NVACBN <> 0
     C                   EVAL      WAACBN = CHACBN
     C                   IF        W3UNCF = 'Y' OR
     C                             A_NVACBN <> WAACBN
     C                   EVAL      WACBNX = 'Y'
     C                   EVAL      WATCH = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        ValidIntBnk <> *BLANKS
     C                   IF        W3UNCF = 'Y' OR
     C                             ValidIntBnk <> CHIntBnk
     C                   EVAL      WINBXX = 'Y'
     C                   EVAL      WATCH = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRCLR - Clear all positions in store                         *
      *                                                              *
      ****************************************************************
     C     SRCLR         BEGSR

      ** Clear arrays in AOSPOSU0
     C                   CLEAR                   C#DTA
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*CLEAR  '    W0ACT
     C                   PARM      C#DTA         O#DTA

     C     *IN90         IFEQ      '1'
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     'AOSPOSU0'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * DAFDT - Subroutine to obtain DAF date formats 'CC' & 'YYMMDD'*
      *                                                              *
      ****************************************************************
     C     DAFDT         BEGSR

     C                   MOVE      WDATE1        WDATE2
     C                   MOVEL     WDATE1        WDATE4

     C                   IF        *IN98 = *ON
     C                   MOVE      WDATE4        WDATE3
     C                   MOVEL     WDATE2        WDATE3
     C                   ELSE
     C                   MOVE      WDATE4        WDATE5
     C                   MOVEL     WDATE4        WDATE6
     C                   MOVEL     WDATE5        WDATE4
     C                   MOVE      WDATE6        WDATE4
     C                   MOVE      WDATE4        WDATE3
     C                   MOVEL     WDATE2        WDATE3
     C                   ENDIF

     C                   IF        WDATE2 < 72
     C                   MOVE      '20'          WDATE2
     C                   ELSE
     C                   MOVE      '19'          WDATE2
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRWTCH  - Send transaction details to Compliance Engine      *
      *                                                              *
      ****************************************************************
     C     SRWTCH        BEGSR

      ** Convert Nostro to customer details
     C                   MOVEL     ACBN          PINP1
     C                   EVAL      PCCY = CCY
     C                   EXSR      SRFRMT

      ** Set-up first parameter for Compliance Engine Program
     C                   EVAL      W4IDEN =  TFRF
     C                   EVAL      W4ITEM =  'FTNOST'
     C                   EVAL      W4BRCH =  BRCA
     C                   IF        CSC011 = 'Y'
     C                   EVAL      W4SYSM =  S1MAIN
     C                   ELSE
     C                   EVAL      W4SYSM = LIBR
     C                   ENDIF
     C                   EXSR      SRCTRP
     C                   EVAL      W4FUNT =  'NTRANDD'
     C                   EVAL      W4CNUM =  PKEY1
     C                   EVAL      W4CTYP =  WCTYP
     C                   EVAL      W4CUST =  WRNRT
     C                   EVAL      W4DDAT =  *ZERO
     C                   EVAL      W4VDAT =  VDAT
     C                   EVAL      W4MDAT =  *ZERO
     C                   EVAL      W4DEN1 =  CCY
     C                   EVAL      W4DEN2 =  *BLANKS
     C                   EVAL      W4AMT1 =  AMNT
     C                   EVAL      W4AMT2 =  *ZERO

      ** Set-up second parameter for Compliance Engine Program
     C                   EVAL      PXML = *BLANKS
      *
      *** Destination
     C                   IF        WACBNX = 'Y'
     C                   MOVEL     ACBN          PINP1
     C                   EXSR      SRFRMT
     C     PXML          CAT       OPTAG(1):0    PXML
     C     PXML          CAT       POUT:0        PXML
     C     PXML          CAT       CLTAG(1):0    PXML
     C                   ENDIF
      *
      *** Nostro
     C                   IF        WDESTX = 'Y'
     C                   MOVEL     DEST          PINP1
     C                   EXSR      SRFRMT
     C     PXML          CAT       OPTAG(2):0    PXML
     C     PXML          CAT       POUT:0        PXML
     C     PXML          CAT       CLTAG(2):0    PXML
     C                   ENDIF
      *
      *** Intermediary Bank
     C                   IF        WINBXX = 'Y'
     C                   MOVEL     NTINB1        PINP1
     C                   MOVEL     NTINB2        PINP2
     C                   MOVEL     NTINB3        PINP3
     C                   MOVEL     NTINB4        PINP4
     C                   MOVEL     NTINB5        PINP5
     C                   EXSR      SRFRMT
     C     PXML          CAT       OPTAG(3):0    PXML
     C     PXML          CAT       POUT:0        PXML
     C     PXML          CAT       CLTAG(3):0    PXML
     C                   ENDIF

      ** Send transaction details to Compilance Watch by calling
      ** dummy program that will call the watch list enqine.
     C                   CALL      'SDWLCLOP'
     C                   PARM                    PSDWLT
     C                   PARM                    PXML

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRFRMT  - Format watch list fields for second parameter      *
      *                                                              *
      ****************************************************************
     C     SRFRMT        BEGSR

     C                   CALL      'SDCWLFMT'
     C                   PARM                    PRTCD
     C                   PARM                    PINP1
     C                   PARM                    PINP2
     C                   PARM                    PINP3
     C                   PARM                    PINP4
     C                   PARM                    PINP5
     C                   PARM                    PINP6
     C                   PARM                    PCCY
     C                   PARM                    POUT
     C                   PARM                    POUT2

     C                   MOVE      *BLANKS       PINP1
     C                   MOVE      *BLANKS       PINP2
     C                   MOVE      *BLANKS       PINP3
     C                   MOVE      *BLANKS       PINP4
     C                   MOVE      *BLANKS       PINP5
     C                   MOVE      *BLANKS       PINP6

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRCTRP - Process counter party details                       *
      *                                                              *
      ****************************************************************
     C     SRCTRP        BEGSR

     C                   EVAL      PKEY1 = POUT2

      ** Get customer detail
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Assemble counterparty report information
     C     BBCRNM        CAT       BBCRTN        WRNRT

      ** Determine counterparty type
     C                   IF        CCF001 = 'Y'
      *
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      WCTYP = 'C'
     C                   ELSE
     C                   EVAL      WCTYP = 'I'
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        BBLICD <> *BLANKS AND
     C                             BBLICD <> W1IND1  AND
     C                             BBLICD <> W1IND2  AND
     C                             BBLICD <> W1IND3  AND
     C                             BBLICD <> W1IND4  AND
     C                             BBLICD <> W1IND5
     C                   EVAL      WCTYP = 'C'
     C                   ELSE
     C                   EVAL      WCTYP = 'I'
     C                   ENDIF
      *
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRADD - Add shadow positions to store                        *
      *                                                              *
      ****************************************************************
     C     SRADD         BEGSR

      ** Define amount
     C     *LIKE         DEFINE    AMNT          ##AMNT

      ** Move fields to C#DTA structure and call AOSPOSU0
      *
      *         S E T T L E    I N S T R U C T I O N S
      *
      * A C C O U N T   W I T H   B A N K
     C                   CLEAR                   C#DTA
     C                   EVAL      C#ATYP = 'N'
     C                   MOVEL     ACBN          C#ACCT
     C                   EXSR      SRACCT
     C                   Z-ADD     VDAT          C#VDAT
      *
      ** Set posting date according to FT Control Data
     C                   IF        C#PDTI = 'I'
     C                   Z-ADD     BJRDNB        C#PSTD
     C                   ELSE
     C                   Z-ADD     VDAT          C#PSTD
     C                   END
      *
     C                   EVAL      C#IO = *BLANKS
     C                   EVAL      C#CCY = CCY
     C                   EVAL      C#TRYP = PYTP
     C                   EVAL      C#PREF = TFRF
     C                   IF        CRE020 = 'Y'
     C                   EVAL      C#NARR = TFRF
     C                   Z-ADD     1             C#CHQN
     C                   IF        WRVAST = 'Y'
     C                   MOVE      '*'           C#NARR
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     ##AMNT        C#AMT
     C                   EVAL      C#MOD = 'FT'
     C                   EVAL      C#OLRC = '01'
     C                   EVAL      C#FTOV = ##FTOV
     C                   EVAL      C#RPST = 'Y'
     C                   Z-ADD     10            C#RPNB
     C                   EVAL      C#RTYP = 'D'
     C                   IF        CAP205 = 'Y'
     C                   EVAL      C#MTYP = 'S'
     C                   ENDIF
      *
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*ADD    '    W0ACT
     C                   PARM      C#DTA         O#DTA
      *
     C     *IN90         IFEQ      '1'
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     'AOSPOSU0'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *         P A Y    I N S T R U C T I O N S
      *
      * D E S T I N A T I O N
     C                   CLEAR                   C#DTA
     C                   EVAL      C#ATYP = 'N'
     C                   MOVEL     DEST          C#ACCT
     C                   EXSR      SRACCT
     C                   Z-ADD     VDAT          C#VDAT
      *
      ** Set posting date according to FT Control Data
     C                   IF        C#PDTI = 'I'
     C                   Z-ADD     BJRDNB        C#PSTD
     C                   ELSE
     C                   Z-ADD     VDAT          C#PSTD
     C                   END
      *
     C                   EVAL      C#IO = *BLANKS
     C                   EVAL      C#CCY = CCY
     C                   EVAL      C#TRYP = PYTP
     C                   EVAL      C#PREF = TFRF
     C                   IF        CRE020 = 'Y'
     C                   EVAL      C#NARR = TFRF
     C                   Z-ADD     2             C#CHQN
     C                   IF        WRVAST = 'Y'
     C                   EVAL      WRVAST = *BLANKS
     C                   MOVE      '*'           C#NARR
     C                   ENDIF
     C                   ENDIF
     C                   Z-SUB     ##AMNT        C#AMT
     C                   EVAL      C#MOD = 'FT'
     C                   EVAL      C#OLRC = '01'
     C                   EVAL      C#FTOV = ##FTOV
     C                   EVAL      C#RPST = 'Y'
     C                   Z-ADD     20            C#RPNB
     C                   EVAL      C#RTYP = 'C'
     C                   IF        CAP205 = 'Y'
     C                   EVAL      C#MTYP = 'S'
     C                   ENDIF
      *
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*ADD    '    W0ACT
     C                   PARM      C#DTA         O#DTA
      *
     C     *IN90         IFEQ      '1'
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     'AOSPOSU0'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRACCT - Moves relevant account data                         *
      *                                                              *
      ****************************************************************
     C     SRACCT        BEGSR

     C                   MOVE      W#CNU1        C#CNU1
     C                   MOVE      W#CCY1        C#CCY1
     C                   MOVE      W#ACO1        C#ACO1
     C                   MOVE      W#ACS1        C#ACS1
     C                   MOVE      W#BRC1        C#BRC1
     C                   MOVE      W#NOSN        C#NOSN
     C                   MOVE      W#NOS         C#NOS
     C                   MOVE      W#ACNO        C#ACNO

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRUPD - Update database with shadow positions                *
      *                                                              *
      ****************************************************************
     C     SRUPD         BEGSR

      ** Call AOSPOSU0 to update database
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*UPDATE '    W0ACT
     C                   PARM      C#DTA         O#DTA
      *
     C     *IN90         IFEQ      '1'
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     'AOSPOSU0'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * UTRLR - Update trailer file                                  *
      *                                                              *
      ****************************************************************
     C     UTRLR         BEGSR

     C     1             CHAIN     NTRANZZ

     C                   IF        NOT %FOUND
     C                   MOVEL     'NTRANZZ'     DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*CHAIN  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Z-ADD     HRWN          ZZTOTI
     C                   Z-ADD     HRDC          ZZTOTD

     C                   IF        A_NVCHTP = 'I'
     C                   ADD       1             NORE1
     C     A_NVAMNT      DIV       1000          ZZAMT
     C                   ENDIF

     C                   IF        A_NVCHTP = 'A'
     C     A_NVAMNT      DIV       1000          ZZAMT1
     C     CHAMNT        DIV       -1000         ZZAMT
     C                   ADD       ZZAMT1        ZZAMT
     C                   ENDIF

     C                   IF        ZZAMT <> 0
     C                   Z-ADD     ZZAMT         ZZAMTI
     C**********         Z-ADD     ZZAMT         ZZAMTD                                     MD032097
     C                   MOVE      ZZAMT         ZZAMTD                                     MD032097
     C                   EXSR      GLZSUM
     C                   ENDIF

     C                   Z-ADD     ZZTOTI        HRWN
     C                   Z-ADD     ZZTOTD        HRDC

     C                   UPDATE    NTRANZZF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * GLZSUM - Computes for total integer and decimal values       *
      *                                                              *
      ****************************************************************
     C     GLZSUM        BEGSR

     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN99 = *OFF

      ** Determine sign of ZZAMTI & ZZAMTD, Seton 92 if negative
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND

      ** Determine sign of ZZTOTI & ZZTOTD, Seton 91 if negative
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193

      ** If ZZTOTAL is zero, return ZZAMOUNT
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND

      ** If signs differ, bypass overflow checks
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS

     C     ZZAMTD        ADD       ZZTOTD        ZZWK2
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93

     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3

      ** If the modulus of ZZWK3 is LT modulus of ZZTOTI
      ** then O/F has occured
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI

      ** If O/F zeroise ZZAMT, Ind '99' set and ZZTOT fields left intact
     C   99              Z-ADD     0             ZZAMT
     C                   GOTO      ZZSEND

      ** The 'SIGNS' are different
     C     ZZOFPS        TAG

      ** If ZZAMT is negative, make it pos. to comp with ZZTOT
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD

      ** If ZZTOT is negative, make it pos. to comp with ZZAMT
     C*
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD

     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95

      ** If ZZTOT equal ZZAMT, return zero
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND

      ** If ZZTOT GT ZZAMT
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD

      ** If ZZAMT GT ZZTOT
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD

      ** Reverse sign of ZZTOT if larger I/P fields are negative
     C                   EVAL      *IN94 = *OFF
     C   93
     CAN 91
     CORN93
     CAN 92              EVAL      *IN94 = *ON
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD

      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG

      ** If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.
     C                   EVAL      *IN96 = *OFF
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZSRSRC,ZDATE2Z2LE
      ********************************************************************
      /EJECT
      ********************************************************************
** CPY@
(c) Finastra International Limited 2014
** OPTAG
<Destination>
<Nostro>
<Intermediary Bank>
** CLTAG
</Destination>
</Nostro>
</Intermediary Bank>
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
