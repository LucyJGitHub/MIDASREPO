     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details - BEI and Fund Info')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCUSD8DP - Customer Details Display - BEI & Fund Info       *
      *                                                               *
      *  Function:  This module displays the BEI and Fund details     *
      *             screen of the Customer Details input function     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT050             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG14653           Date 23Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2950            Date 02Jun04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW024 *Create     Date 31Aug01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14653 - Errors encountered in Customer Repair API         *
      *             (Recompile)                                       *
      *  CSW037A- Additional Field extended to 40 chars               *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2950- Recompiled due to changed DSPF/SDCUSD8DDF.          *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCUSD8DDFCF   E             WORKSTN
 
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
      *       97  Subfile end                                         *
      *       99  Read error                                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D CuPrim        E DS                  EXTNAME(SDCUPRPD)
     D CuMT3x        E DS                  EXTNAME(SDCUMTPD)
     D OKCuBEIF      E DS                  EXTNAME(SDECUMTPD)
      ** External DS for SAR Details                                                          CFT050
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT050
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D CFT050          S              1                                                       CFT050
     D CFT004          S              1                                                       CFT050
     D WDDBDRK         S             12A                                                      CFT050
     D @INKV           S              1A                                                      CFT050
     D @EINKV          S              1A                                                      CFT050
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      ** Enable F21 key                                                                       CFT050
     C                   EVAL      *IN79 = *OFF                                               CFT050
     C                   IF        CFT050 = 'Y'                                               CFT050
     C                             AND CFT004 = 'Y'                                           CFT050
      *                                                                                       CFT050
     C                   SELECT                                                               CFT050
     C                   WHEN      DDACTN = 'I'                                               CFT050
     C                   EVAL      *IN79 = *ON                                                CFT050
     C                   EVAL      DFCF21 = 'F21=Link  '                                      CFT050
      *                                                                                       CFT050
     C                   WHEN      DDACTN = 'A'                                               CFT050
     C                   EVAL      *IN79 = *ON                                                CFT050
     C                   EVAL      DFCF21 = 'F21=Link  '                                      CFT050
     C                   IF        WDDBDRK <> *BLANKS                                         CFT050
     C                   EVAL      DFCF21 = 'F21=Unlink'                                      CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C                   ENDSL                                                                CFT050
      *                                                                                       CFT050
     C                   ENDIF                                                                CFT050
 
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
      ** Main processing
      *
     C                   EXSR      MAIN
      *
      ** Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     OKCuBEIF      @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
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
      *
      ** Set up the transaction reference to be used by the message handler
      *
     C                   EVAL      TranRef = DDCUSN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      *
      ** Position cursor on first field if no errors
      *
     C     'N'           LOOKUP    @EI                                    69
      *
      ** Protect all fields
      *
     C                   MOVE      *OFF          *IN70
     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C     DDACTN        WHENEQ    'A'
     C                   OTHER
     C                   MOVE      *ON           *IN70
     C                   ENDSL
      *
      ** Enable function keys
      *
     C     @EINKJ        COMP      'Y'                                    72
     C     @EINKX        COMP      'Y'                                    73
      *
      ** Write message subfile, details and footer screen
      *
     C                   TIME                    DDTIME
     C                   WRITE     SDCUSDSS0
     C                   WRITE     SDCUSDSD1
     C                   WRITE     SDCUSDSF1
      *
      ** Read details screen, if not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      SDCUSDSD1                              99
     C                   ENDIF
 
      * Set screen error indicators off
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * Set return keys
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
      * INPUT Parameters :
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Trade (IN SCREEN FORMAT - Primary / MT3X BEI & Fund Details)
     C                   PARM                    CuPrim
     C                   PARM                    CuMT3X
      * Fields in error
     C                   PARM                    OKCuBEIF
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
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      ** Linkage record key                                                                   CFT050
     C                   PARM                    WDDBDRK                                      CFT050
      *
      * OUTPUT Parameters :
      * Function keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKX             1
     C                   PARM                    @INKV                                        CFT050
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSD8DP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
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
      *                                                                                      CSW037A
      ** Check if switchable feature CSD025 is switched on.                                  CSW037A
      *                                                                                      CSW037A
     C                   CALL      'AOSARDR0'                                                CSW037A
     C                   PARM      *BLANKS       @RTCD                                       CSW037A
     C                   PARM      '*VERIFY'     @OPTN                                       CSW037A
     C                   PARM      'CSW037'      @SARD                                       CSW037A
      *                                                                                      CSW037A
      ** DATABASE ERROR                                                                      CSW037A
      *                                                                                      CSW037A
     C                   MOVE      *ON           *IN66                                       CSW037A
      *                                                                                      CSW037A
     C     @RTCD         IFNE      *BLANKS                                                   CSW037A
     C     @RTCD         ANDNE     '*NRF   '                                                 CSW037A
     C                   MOVEL     'CSW037'      DBKEY                                       CSW037A
     C                   MOVEL     'SCSARDPD'    DBFILE                                      CSW037A
     C                   MOVEL     '910'         DBASE                                       CSW037A
     C                   EXSR      SRERR                                                     CSW037A
     C                   END                                                                 CSW037A
      *                                                                                      CSW037A
     C     @RTCD         IFEQ      *BLANKS                                                   CSW037A
     C                   MOVE      *OFF          *IN66                                       CSW037A
     C                   ENDIF                                                               CSW037A
      *                                                                                       CFT050
      ** Check if switchable feature CFT050 is switched on.                                   CFT050
      *                                                                                       CFT050
     C                   CALLB     'AOSARDR0'                                                 CFT050
     C                   PARM      *BLANKS       @RTCD                                        CFT050
     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
     C                   PARM      'CFT050'      @SARD                                        CFT050
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT050
                                                                                              CFT050
     C     @RTCD         IFNE      *BLANKS                                                    CFT050
     C     @RTCD         ANDNE     '*NRF   '                                                  CFT050
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT050
     C                   MOVEL     '902'         DBASE                                        CFT050
     C                   MOVEL     @SARD         DBKEY                                        CFT050
     C                   EXSR      SRERR                                                      CFT050
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
     C                   MOVEL     'N'           CFT050                                       CFT050
     C     @RTCD         IFEQ      *BLANKS                                                    CFT050
     C                   MOVEL     'Y'           CFT050                                       CFT050
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
     C                   MOVEL     '903'         DBASE                                        CFT050
     C                   MOVEL     @SARD         DBKEY                                        CFT050
     C                   EXSR      SRERR                                                      CFT050
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
     C                   MOVEL     'N'           CFT004                                       CFT050
     C     @RTCD         IFEQ      *BLANKS                                                    CFT050
     C                   MOVEL     'Y'           CFT004                                       CFT050
     C                   ENDIF                                                                CFT050
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY SDCPYSRC,MSGHNDDATA
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
     C                   MOVEL     'SDCUSD8DP'   DBPGM
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
(c) Finastra International Limited 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
