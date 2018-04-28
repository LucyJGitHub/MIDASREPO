     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details - secondary screen')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDCUSD3DP - Customer Details Display - Secondary Screen     *
      *                                                               *
      *  Function:  This module displays the secondary details screen *
      *             of the Customer Details input function            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSW214             Date 25Nov14               *
      *  Prev Amend No. MD022854           Date 14Oct13               *
      *                 CFT050             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207A            Date 02Aug07               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2950            Date 02Jun04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 191530             Date 05Jun01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189507             Date 02Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 25May99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  MD022854 - No Legal entity identifier for input              *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD025 - Customer De-Activation                              *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2950- Recompiled due to changed DSPF/SDCUSD3DDF.          *
      *  BUG2950- Recompiled due to changed DSPF/SDCUSD3DDF.          *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  191530 - SDCUSDSIN - Unable to send msg RE7105B.  Need to    *
      *           recompile pgm to pick up changes made in cpysrc     *
      *           MSGHNDDATA.                                         *
      *  189507 - Change setup of CLS fields in Customer details and  *
      *           FX deals input - make them available ALWAYS, if     *
      *           CDL008 is installed                                 *
      *  CSD007 - Customer Closing: Recompile.                        *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCUSD3DDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *       69 Postion cursor to first screen field if no errors    *
      *       70 Protect screen fields                                *
      *       72 Enable function key F10 (delete)                     *
      *       73 Enable function key F23 (further details)            *
      *       80 Condition display of auto-reconciliation field       *
      *       81 CDL008 is not installed                              *                       CDL008
      ********82*Protect*CLS*Settlement*and*Effective*Date*************                CDL008 189507
      *       83 Check if Midas/ToF Interface feature is present      *
      *       83 Check if Midas/ToF Interface feature is present      *
      *       84 CSW036 is not installed                              *
      *       89 Condition display of Corporate Customer fields       *
      *       97  Subfile end                                         *
      *       99  Read error                                          *
      ********************************************************************
      /EJECT
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
 
     D @EI             S              1    DIM(60)
 
 
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ***External*DS*for*Branch*Details***                                             CDL008 189507
     D***SDBRCH********E*DS                  EXTNAME(SDBRCHPD)                         CDL008 189507
                                                                                              CDL008
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D CuPrim        E DS                  EXTNAME(SDCUPRPD)
     D CuSeco        E DS                  EXTNAME(SDCUSEPD)
     D CuSwft        E DS                  EXTNAME(SDCUSWPD)                                  CSW207
     D OKCuSeco      E DS                  EXTNAME(SDECUSEPD)
     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CFT050
     D CuSW13        E DS                  EXTNAME(SDSW13PD)                                  CFT050
     D  S13DDBRCD    E                     EXTFLD(DDBRCD)                                     CFT050
     D/COPY WNCPYSRC,SDCUS3XD01
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CFT050          S              1A                                                      CFT050
     D CFT004          S              1A                                                      CFT050
     D @INKV           S              1A                                                      CFT050
     D @EINKV          S              1A                                                      CFT050
     D CSW213          S              1A                                                    MD022854
     D PRTCD           S              7A                                                    MD022854
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
      *
      ** Enable F21 key                                                                       CFT050
     C                   EVAL      *IN78 = '0'                                                CFT050
     C                   IF        CSW213 = 'Y'                                             MD022854
     C                   EVAL      *IN78 = '1'                                              MD022854
     C                   ENDIF                                                              MD022854
     C                   EVAL      *IN79 = '0'                                                CFT050
     C                   IF        CFT050 = 'Y'                                               CFT050
     C                             AND CFT004 = 'Y'                                           CFT050
     C**********         EVAL      *IN78 = '1'                                       CFT050 MD022854
      *                                                                                       CFT050
     C                   SELECT                                                               CFT050
     C                   WHEN      DDACTN = 'I'                                               CFT050
     C                   EVAL      *IN79 = *ON                                                CFT050
     C                   IF        DDBDRK =  *BLANKS                                          CFT050
     C                   EVAL      DFCF21 = 'F21=Link  '                                      CFT050
     C                   ELSE                                                                 CFT050
     C                   EVAL      DFCF21 = 'F21=Unlink'                                      CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C                   WHEN      DDACTN = 'A'                                               CFT050
     C                   EVAL      *IN79 = *ON                                                CFT050
     C                   EVAL      DFCF21 = 'F21=Link  '                                      CFT050
     C                   IF        DDBDRK <> *BLANKS                                          CFT050
     C                   EVAL      DFCF21 = 'F21=Unlink'                                      CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C                   ENDSL                                                                CFT050
      *                                                                                       CFT050
     C                   ENDIF                                                                CFT050
      * Main processing
      *
     C                   EXSR      MAIN
      *
      * Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     OKCuSeco      @EI
     C                   IF        CFT050 = 'Y'                                               CFT050
     C                   MOVEA     DDLEICOK      @EI(18)                                      CFT050
     C                   MOVEA     DDCLSYOK      @EI(19)                                      CFT050
     C                   MOVEA     DDCLIDOK      @EI(20)                                      CFT050
     C                   ENDIF                                                                CFT050
     C/COPY WNCPYSRC,SDCUS3XC01
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
 
 
      ** Set up the transaction reference to be used by the message handler
     C                   EVAL      TranRef = DDCUSN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      *
      ** Set screen conditioning indicators
      *
     C     CCF001        IFEQ      'N'
     C                   MOVE      *ON           *IN89
     C                   ENDIF
      *
     C     BGAURC        IFEQ      'N'
     C                   MOVE      *ON           *IN80
     C                   ENDIF
      ***********                                                                      CDL008 189507
      ***If*CDL008*is*on,*but*'Default*CLS*by*Customer'*is*NOT*'Y',***                 CDL008 189507
      ***protect*'CLS*Settlement'*and*'Effective*Date'.***                             CDL008 189507
      ***********                                                                      CDL008 189507
     C*****CDL008        IFEQ      'Y'                                                 CDL008 189507
     C***********        CALL      'AOBRCHR1'                                          CDL008 189507
     C***********        PARM      *BLANKS       WRTCD             7                   CDL008 189507
     C***********        PARM      '*KEY   '     WOPTN             7                   CDL008 189507
     C***********        PARM      DDBRCD        WBRCD             3                   CDL008 189507
     C*****SDBRCH        PARM      SDBRCH        DSSDY                                 CDL008 189507
      ***********                                                                      CDL008 189507
     C*****A8DCLC        IFEQ      'Y'                                                 CDL008 189507
     C***********        MOVE      *OFF          *IN82                                 CDL008 189507
     C***********        ELSE                                                          CDL008 189507
     C***********        MOVE      *ON           *IN82                                 CDL008 189507
     C***********        ENDIF                                                         CDL008 189507
     C***********        ENDIF                                                         CDL008 189507
      *
      ** Position cursor on first field if no errors
      *
     C     'N'           LOOKUP    @EI                                    69
      *
      * Protect all fields
      *
     C                   MOVE      *OFF          *IN70
     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C     DDACTN        WHENEQ    'A'
     C                   OTHER
     C                   MOVE      *ON           *IN70
     C                   ENDSL
      *
      * ENABLE FUNCTION KEYS
      *
     C     @EINKJ        COMP      'Y'                                    72
     C     @EINKX        COMP      'Y'                                    73
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     SDCUSDSS0
     C                   WRITE     SDCUSDSD1
     C                   WRITE     SDCUSDSF1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C                   READ      SDCUSDSD1                              99
      *
      ** IF EXIT/PREVIOUS SCREEN NOT SELECTED
      ** PROCESS USER REQUEST FOR DATA TABLES WITH QUERY '?'
      *
     C     @INKC         IFNE      *ON
     C     @INKL         ANDNE     *ON
      *
      * Corporate Customer
     C                   MOVEL     DDCRPC        QRYFLD            1
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM                    RETURN            7
     C                   PARM      1193665       Y2LSNO            7 0
     C     DDCRPC        PARM                    SELECTION        20
     C                   ENDIF
      *
      * SWIFT Financial Insitution Indicator
     C                   MOVEL     DDSWFI        QRYFLD            1
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM                    RETURN            7
     C                   PARM      1214277       Y2LSNO            7 0
     C     DDSWFI        PARM                    SELECTION        20
     C                   ENDIF
 
     C                   ENDIF
 
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKX         @INKX
     C                   MOVE      *INKV         @INKV                                        CFT050
      *
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Trade (IN SCREEN FORMAT - Primary / Secondary)
     C                   PARM                    CuPrim
     C                   PARM                    CuSeco
     C                   PARM                    CuSwft                                       CSW207
     C                   PARM                    CuSW13                                       CFT050
      * Fields in error
     C                   PARM                    OKCuSeco
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED FUNCTION KEYS
      * KJ = COMMAND KEY 10 = DELETE
      * KX = COMMAND KEY 20 = FURTHER DETAILS
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKX            1
     C                   PARM                    @EINKV                                       CFT050
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKX             1
     C                   PARM                    @INKV                                        CFT050
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
     C/COPY WNCPYSRC,SDCUS3XC02
      *
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSD3DP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      * SET SCREEN PROTECT/NON-DISPLY INDICATORS
      *
      *
      ** Check if Midas/ToF Interface feature is present
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP050'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAP050            1
     C                   ELSE
     C                   MOVE      'N'           CAP050
     C                   MOVE      *ON           *IN83
     C                   ENDIF
 
      *
      ** Check if switchable feature CCF001 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CCF001'      @SARD
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CCF001            1
     C                   ELSE
     C                   MOVE      'N'           CCF001
     C                   END
      *                                                                                       CDL008
      ** Check if CDL008 (Continuous Linked Settlement) is on.                                CDL008
      *                                                                                       CDL008
     C                   CALLB     'AOSARDR0'                                                 CDL008
     C                   PARM      *BLANKS       @RTCD                                        CDL008
     C                   PARM      '*VERIFY'     @OPTN                                        CDL008
     C                   PARM      'CDL008'      @SARD                                        CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL008
      *                                                                                       CDL008
     C     @RTCD         IFEQ      *BLANKS                                                    CDL008
     C                   MOVE      'Y'           CDL008            1                          CDL008
     C                   MOVE      *OFF          *IN81                                        CDL008
     C                   ELSE                                                                 CDL008
     C                   MOVE      'N'           CDL008                                       CDL008
     C                   MOVE      *ON           *IN81                                        CDL008
     C                   ENDIF                                                                CDL008
      *                                                                                       CSW036
      ** Check if CSW036 is on.                                                               CSW036
      *                                                                                       CSW036
     C                   CALLB     'AOSARDR0'                                                 CSW036
     C                   PARM      *BLANKS       @RTCD                                        CSW036
     C                   PARM      '*VERIFY'     @OPTN                                        CSW036
     C                   PARM      'CSW036'      @SARD                                        CSW036
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW036
      *                                                                                       CSW036
     C     @RTCD         IFEQ      *BLANKS                                                    CSW036
     C                   MOVE      'Y'           CSW036            1                          CSW036
     C                   MOVE      *OFF          *IN84                                        CSW036
     C                   ELSE                                                                 CSW036
     C                   MOVE      'N'           CSW036                                       CSW036
     C                   MOVE      *ON           *IN84                                        CSW036
     C                   ENDIF                                                                CSW036
      *                                                                                       CFT050
      ** Check if switchable feature CFT050 is switched on.                                   CFT050
      *                                                                                       CFT050
     C                   MOVEL     'N'           CFT050                                       CFT050
     C                   CALLB     'AOSARDR0'                                                 CFT050
     C                   PARM      *BLANKS       @RTCD                                        CFT050
     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
     C                   PARM      'CFT050'      @SARD                                        CFT050
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT050
                                                                                              CFT050
     C     @RTCD         IFNE      *BLANKS                                                    CFT050
     C     @RTCD         ANDNE     '*NRF   '                                                  CFT050
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT050
     C                   MOVEL     '906'         DBASE                                        CFT050
     C                   MOVEL     @SARD         DBKEY                                        CFT050
     C                   EXSR      SRERR                                                      CFT050
     C                   ELSE                                                                 CFT050
     C     @RTCD         IFEQ      *BLANKS                                                  MD022854
     C                   MOVEL     'Y'           CFT050                                       CFT050
     C                   ENDIF                                                              MD022854
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
      ** Check if switchable feature CFT004 is switched on.                                   CFT050
      *                                                                                       CFT050
     C                   CALLB     'AOSARDR0'                                                 CFT050
     C                   PARM      *BLANKS       @RTCD                                        CFT050
     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
     C                   PARM      'CFT004'      @SARD                                        CFT050
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT050
                                                                                              CFT050
     C     @RTCD         IFNE      *BLANKS                                                    CFT050
     C     @RTCD         ANDNE     '*NRF   '                                                  CFT050
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT050
     C                   MOVEL     '907'         DBASE                                        CFT050
     C                   MOVEL     @SARD         DBKEY                                        CFT050
     C                   EXSR      SRERR                                                      CFT050
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
     C                   MOVEL     'N'           CFT004                                       CFT050
     C     @RTCD         IFEQ      *BLANKS                                                    CFT050
     C                   MOVEL     'Y'           CFT004                                       CFT050
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
      *                                                                                     MD022854
      ** Check if SWIFT 2013 is installed                                                   MD022854
      *                                                                                     MD022854
     C                   CALL      'SWIF2013'                                               MD022854
     C                   PARM      *BLANKS       PRTCD                                      MD022854
                                                                                            MD022854
     C                   IF        PRTCD   = 'CSW2013'                                      MD022854
     C                   EVAL      CSW213 = 'Y'                                             MD022854
     C                   ELSE                                                               MD022854
     C                   EVAl      CSW213 = 'N'                                             MD022854
     C                   ENDIF                                                              MD022854
      *
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SDCUSD2DP'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
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
** @Z0
000000000000000000000000000000000000000000000000000000000000
