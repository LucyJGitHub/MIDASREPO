     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CLS Pay-in Schedule Browse')
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXCLSPBRW - FX CLS Pay-in Schedule Browse                    *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of CLS Pay-in schedule for     *
      *             selection ,the other picks off the selection made.*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187923             Date 20Dec00               *
      *                 187730             Date 15Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  187923 - 2 tier authorisation for CLS pay-in schedules       *
      *           (Recompiled)                                        *
      *  187730 - Allow enquiry of deleted CLS pay-in schedules       *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFXCLSPBDF CF   E             WORKSTN
     F                                     SFILE(FXCLSPS0:@@RRN)
     FFXCLSPSHL0IF   E           K DISK    INFSR(*PSSR)
     FFXCLSPSHL2IF   E           K DISK    RENAME(FXCLPHD0:FXCLPHD2)
     F                                     INFSR(*PSSR)
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** External DS for Dealing Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZDATE2
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
 
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
      *
      ** Initialisation
      *
     C                   EXSR      INIT
      *
      ** Build Sub-File
      *
     C     @BDSFLB       IFEQ      'Y'
     C                   EXSR      BLDSFL
     C                   ENDIF
      *
      ** Read Subfile Record
      *
     C     @RDSFLB       IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - Build Subfile
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** Check for user authority to Browse if not multi-branching
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ** Validate key fields
      *
     C                   EXSR      VALKEY
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     FXCLSPC0
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     FXCLSPF1
      *
      **  Set file pointer on key displayed on screen.
      *
     C     DDACTN        IFEQ      'X'
     C     KYCLSP        SETLL     FXCLSPSHL2
     C                   ELSE
     C     KYCLSP        SETLL     FXCLSPSHL0
     C                   ENDIF
      *
      ** Read a valid CLS Pay-in Schedule
      *
     C                   EXSR      RDCLSP
      *
      **  If no records exist - set up an error message.
      **  and terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      * Format CLS Pay-in schedule fields for output
      *
     C                   EXSR      FMTCLS
      *
      ** Write the CLS schedule to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     FXCLSPS0
      *
      ** Read A Valid CLS Pay-in schedule
      *
     C                   EXSR      RDCLSP
     C                   ENDDO
      *
      ** Write the subfile control record to the screen to display
      ** the subfile.
      *
     C                   WRITE     FXCLSPC0
      *
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
      *
     C                   READ      FXCLSPC0                               99
      *
      ** If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - Read Subfile Record
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      ** Read the subfile for selected records
      ** Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C                   READC     FXCLSPS0                               99
     C                   ENDDO
      *
      **  Return the selected CLS pay schedule details and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C     DDOPT         OREQ      'X'
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   ENDIF
      *
     C                   MOVE      DDCCY         @OPCCY
     C                   MOVE      DDNST         @OPNST
     C                   MOVE      DDVDT         @OPVDT
     C                   MOVE      DDSEQ         @OPSEQ
      *
     C                   ENDIF
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTCLS - Format CLS schedule fields for Output
      ******************************************************************
     C     FMTCLS        BEGSR
      *
      ** CLS ccy
      *
     C                   MOVE      PYCCY         DDCCY
      *
      ** CLS nostro
      *
     C                   MOVE      PYNOST        DDNST
      *
      ** CLS Value date
      *
     C                   MOVE      PYVALD        ZDAYNO
     C                   EXSR      CVTDAT
     C                   MOVE      ZDATE         DDVDT
      *
      ** CLS Sequence no.
      *
     C                   MOVE      PYSEQN        DDSEQ
      *
      ** CLS Time difference
      *
     C                   MOVE      PYTIMD        DDTMD
      *
      ** CLS Profit Centre
      *
     C                   MOVE      PYPRFC        DDPRC
      *
      ** CLS Total amount Pay/Rcv
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      PYCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   MOVEL     @AJCD         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     A6NBDP        WNBDP
      *
      ** CLS Pay/Rcv Indicator
      *
     C     PYTOTR        IFNE      0
     C                   Z-ADD     PYTOTR        @@IAMT
     C                   EVAL      DDPOR = 'R'
     C                   ENDIF
     C     PYTOTP        IFNE      0
     C                   Z-ADD     PYTOTP        @@IAMT
     C                   EVAL      DDPOR = 'P'
     C                   ENDIF
      *
      ** CLS Status
      *
     C                   MOVE      PYSNTF        DDSTS
     C                   Z-ADD     18            @@CRET
     C                   Z-ADD     A6NBDP        @@CDP
     C                   EXSR      FMTAMT
     C                   MOVE      @@ADSP        DDAMT
      *                                                                                       187730
      ** Text for 'DELETED' records                                                           187730
      *                                                                                       187730
     C     PYRECI        IFEQ      'D'                                                        187730
     C                   MOVE      *OFF          *IN84                                        187730
     C                   ELSE                                                                 187730
     C                   MOVE      *ON           *IN84                                        187730
     C                   MOVE      'DELETED'     DDTXT                                        187730
     C                   ENDIF                                                                187730
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * RDCLSP - Read a CLS Pay-in schedule
      *****************************************************************
     C     RDCLSP        BEGSR
      *
      ** Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      ** Read the file initially - if @@EOF is set on then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.
      *
      ** Read the file.
      *
     C     @@EOF         DOUEQ     'Y'
     C     PYRECI        OREQ      'D'
     C     PYRECI        ORNE      'D'                                                        187730
      *
     C     DDACTN        IFEQ      'X'
     C                   READ      FXCLSPSHL2                             96
     C                   ELSE
     C                   READ      FXCLSPSHL0                             96
     C                   ENDIF
      *
      ** End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF
     C                   ENDDO
      *
     C     ERDDEL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - Check for user authority if not multi-branching
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** Return error message
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM3023'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALKEY - Validate key fields pointer
      *****************************************************************
     C     VALKEY        BEGSR
      *
      ** Validate that the ccy is valid or blank.
      *
     C     @CLSCCY       IFNE      *BLANKS
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @CLSCCY       @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   MOVE      @CLSCCY       KYCCY
      *
      ** Return Error Message
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'FXM3003'     @ERRMS
     C                   RETURN
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANKS       KYCCY
     C                   ENDIF
      *
      ** Validate that the nostro number is numeric or blank.
      *
     C                   TESTN                   @CLSNST              98
     C                   MOVE      @CLSNST       @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     @CLSNST       IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      @CLSNST       KYNST
      *
      ** Return Error Message
      *
     C                   ELSE
     C                   MOVEL     'FXM3005'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
      ** Validate that the value date is a valid date or blank.
      *
     C     @CLSVDT       IFNE      *BLANKS
     C                   TESTN                   @CLSVDT              98
     C                   MOVE      @CLSVDT       @@TEST
     C                   TESTZ                   @@TEST                   99
     C     *IN98         IFEQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVEL     @CLSVDT       @DAT
     C                   CALLB     'ZA0270'
     C                   PARM                    @DAT              6 0
     C                   PARM                    BJDFIN
     C                   PARM                    @RTCDE            1
     C                   PARM                    @VDYNO            5 0
     C                   ENDIF
     C                   ENDIF
      *
      ** If the return code is 1 then the input date is invalid or
      ** non-numeric.
      *
     C     @RTCDE        IFEQ      '1'
     C     @CLSVDT       ANDNE     *BLANKS
     C*
     C     *IN99         OREQ      '0'
     C     @CLSVDT       ANDNE     *BLANKS
     C*
     C     *IN98         OREQ      '0'
     C     @CLSVDT       ANDNE     *BLANKS
     C*
     C                   MOVEL     'FXM3009'     @ERRMS
     C                   RETURN
     C*
     C                   ELSE
     C     @CLSVDT       IFEQ      *BLANKS
     C                   Z-ADD     0             KYVDT
     C                   ELSE
     C                   Z-ADD     @VDYNO        KYVDT
     C                   ENDIF
     C                   ENDIF
      *
      ** Sequence no. must be numeric if entered
      *
     C     @CLSSEQ       IFNE      *BLANKS
     C*
     C                   TESTN                   @CLSSEQ              98
     C                   MOVE      @CLSSEQ       @@TEST
     C                   TESTZ                   @@TEST                   99
     C                   ENDIF
     C*
     C     @CLSSEQ       IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C*
     C     @CLSSEQ       IFEQ      *BLANKS
     C                   Z-ADD     *LOVAL        KYSEQ
     C                   ELSE
     C                   MOVE      @CLSSEQ       KYSEQ
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL     'FXM3014'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * CVTDAT - Convert Day number to  DDMMYY (OR MMDDYY)            *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDATE
     C                   PARM      *BLanks       ZADATE
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - Format Pay/Receive Total Amount
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA1020'
     C                   PARM                    @@IAMT           15 0
     C                   PARM                    @@CRET            2 0
     C                   PARM                    @@CDP             1 0
     C                   PARM                    BNDCSP
     C                   PARM                    BNTHSP
     C                   PARM      *BLANKS       @@ADSP           21
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Clear Outputs
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @OPCCY
     C                   MOVE      *BLANK        @OPNST
     C                   MOVE      *BLANK        @OPVDT
     C                   MOVE      *BLANK        @OPSEQ
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Input Parameters
      *
     C                   PARM                    RetCodeIn
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * CLS currency pointer
     C                   PARM                    @CLSCCY           3
      *
      * CLS currency nostro
     C                   PARM                    @CLSNST           2
      *
      * CLS currency value date
     C                   PARM                    @CLSVDT           6
      *
      * CLS currency sequence no.
     C                   PARM                    @CLSSEQ           2
      *
      * CLS currency decimal places
     C                   PARM                    WNBDP             1 0
      *
      * Build Subfile
     C                   PARM                    @BDSFLB           1
      *
      * Read Subfile record
     C                   PARM                    @RDSFLB           1
      *
      * Output parameters
     C                   PARM                    @ERRMS            7
      *
      * Option Selected
     C                   PARM                    @OPSEL            1
      *
      * CLS Currency selected
     C                   PARM                    @OPCCY            3
      *
      * CLS Nostro selected
     C                   PARM                    @OPNST            2
      *
      * CLS Value date selected
     C                   PARM                    @OPVDT            6
      *
      * CLS Sequence number selected
     C                   PARM                    @OPSEQ            2
      *
      * Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Initialise program name
      *
     C                   MOVEL     'FXCLSPBRW'   DBPGM
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Dealing details
      *
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      *
      ** Move workstation ID to screen field.
      *
     C                   EVAL      DDUSER = PSUSER
     C                   EVAL      DDRUNA = BJMRDT
     C                   EVAL      DDWSID = PSJOBNAME
      *
     C     KYCLSP        KLIST
     C                   KFLD                    KYCCY             3
     C                   KFLD                    KYNST             2
     C                   KFLD                    KYVDT             5 0
     C                   KFLD                    KYSEQ             2 0
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
