     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas COB Scheduling maintenance/control')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  CB000401 - COB Scheduling Maintenance/Control                *
      *                                                               *
      *  Function:  This program prompt a screen to define scheduling *
      *             conditions and to control status (Restart/Stop)   *

      *             Source converted to RPGLE from OPM program CB0004.*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. MD038993 *CREATE   Date 21Nov16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD038993 - Missing code functionality on CCB014.             *
      *             Define 10 jobs. COB will not run if one of the    *
      *             job is active.                                    *
      *                                                               *
      *****************************************************************
      *
      *     F U N C T I O N   O F   I N D I C A T O R S
      *
      *    11-15         Invalid Input indicators
      *    LR            End of program
      *    U7-U8         Databaser error
      *
      *****************************************************************
      *
     FCB0004DF  CF   E             WORKSTN INFSR(*PSSR)
     FGPZONEL2  IF   E           K DISK    INFSR(*PSSR)
     FCBJOBLPD  UF   E             DISK    INFSR(*PSSR)
      *
      ** COB Scheduling Maintenance/Control Screen
      *
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D TEXT            S             60    DIM(5) CTDATA PERRCD(1)
      *
      ** Array containing Status statement
      *
     D PSDS           SDS
      *
      ** Program status data structure
      *
     D  ##PGM            *PROC
     D  WJBNB                244    253
     D  WUSER                254    263
      *
     D LDA             DS           256
      *
      ** Local data area
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D DLYCOB        E DS                  EXTNAME(DLYCOB)
      *
      ** Data Area giving Scheduled COB Details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      *
      ** Data Area for system details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Bank Details
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Long Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Short Data Structure
      *
     D                 DS
      *
      ** System Dates
      *
     D  SYSD                   1      2
     D  SYSM                   3      4
     D  SYSY                   5      6
     D  SYSN                   1      6  0
      *
     D ZONEDS          DS
     D  WZONE1                 1     10
     D  WZONE2                11     27
     D  WZONE3                28     30
     D  WZONE4                31     31
     D TMDFDS          DS
     D  WTMSGN                 1      1
     D  WHOUR                  2      3  0
     D  WOFFST                 1      3
     D WZONE5          C                   CONST(' Zone (Time Zone ')
      *
     D WRRN            S              3  0
     D WIDX            S              3  0
     D WIDX2           S              3  0
     D WIDX3           S              3  0
     D WIDX4           S              3  0
     D PFRST           S              1
     D PJOBA           S              1

     D                 DS
     D ACTJOB          C                   CONST('CBC000109')
      *
      ** File Job Structure
      *
     D DSJOBF        E DS                  EXTNAME(CBJOBLPD)

     D DSJOBP          DS
     D  PJOBN                        10
     D  PJOBT                         1
     D  PJOBS                         1
      *
      ** Screen Job Structure
      *
     D DSJOBS          DS
     D  #0JBN1                       10
     D  #0JBT1                        1
     D  #0JBC1                        1
     D  #0JBN2                       10
     D  #0JBT2                        1
     D  #0JBC2                        1
     D  #0JBN3                       10
     D  #0JBT3                        1
     D  #0JBC3                        1
     D  #0JBN4                       10
     D  #0JBT4                        1
     D  #0JBC4                        1
     D  #0JBN5                       10
     D  #0JBT5                        1
     D  #0JBC5                        1
     D  #0JBN6                       10
     D  #0JBT6                        1
     D  #0JBC6                        1
     D  #0JBN7                       10
     D  #0JBT7                        1
     D  #0JBC7                        1
     D  #0JBN8                       10
     D  #0JBT8                        1
     D  #0JBC8                        1
     D  #0JBN9                       10
     D  #0JBT9                        1
     D  #0JBC9                        1
     D  #0JBNA                       10
     D  #0JBTA                        1
     D  #0JBCA                        1
      *
      ** Screen Job Status Structure
      *
     D DSJOBA          DS
     D  #0JBS1                       10
     D  #0JBS2                       10
     D  #0JBS3                       10
     D  #0JBS4                       10
     D  #0JBS5                       10
     D  #0JBS6                       10
     D  #0JBS7                       10
     D  #0JBS8                       10
     D  #0JBS9                       10
     D  #0JBSA                       10
      *
      ** Job Type Indicators
      *
     D DSJINT          DS
     D SCRINDT                        1    DIM(10)
      *
      ** Type of Checking Indicators
      *
     D DSJINS          DS
     D SCRINDS                        1    DIM(10)
      *
      ** Job Status Structure
      *
     D DSJOBA1         DS
     D JOBSTAT                        1    DIM(10)

      /EJECT
      *****************************************************************
      *                   Index to subroutines                        *
      *  Main routine                                                 *
      *  #LINIT  -  Initialisation process                            *
      *  #LINTS  -  Initialisation of screen fields                   *
      *  #LINSC  -  Control Status of Scheduling                      *
      *  #LVLDS  -  Validation of screen fields                       *
      *  #LUPDT  -  Update file with screen values                    *
      *  #SCSTR  -  Start Scheduling                                  *
      *  #SCEND  -  End Scheduling                                    *
      *  #ZASNMS -  Send message to program's message queue           *
      *  *PSSR   -  Error handling subroutine                         *
      *****************************************************************
      /EJECT
      *****************************************************************
      *             S T A R T   O F   P R O G R A M                   *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    POFFST            5
      *
      ** Perform the initial processing
      *
     C                   EXSR      #LINIT
      *
      ** Initialise screen fields
      *
     C                   EXSR      #LINTS
      *
      ** Control actual status of scheduling
      *
     C                   EXSR      #LINSC
      *
      ** Active job checking
      *
     C                   EXSR      #ACJOB
      *
      ** Do while F3 is not pressed to exit the program
      *
     C     *INKC         DOWEQ     '0'
      *
      ** Write message subfile for any SPF error
      *
     C                   WRITE     CB0004C0
      *
      ** Update Time Field
      *
     C                   TIME                    STIME
      *
     C                   CALL      'ZDATE2'
     C                   PARM      SYSDAT        WQ0001
     C                   PARM      BJDFIN        WQ0002
     C                   PARM                    WQ0003
     C                   PARM                    WQ0004
      *
     C                   MOVEL     WQ0004        #0SDAT
     C                   TIME                    #0STIM
      *
      ** Accept input
      *
     C                   EXFMT     CB0004F0
      *
      ** If F3 pressed from the main screen, end the program
      *
     C     *INKC         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
      ** Update Screen Job Status
      *
     C                   EXSR      #JOBSC
      *
      ** Validate screen fields
      *
     C                   EXSR      #LVLDS
      *
     C     @ERR          IFEQ      '0'
      *
      *
      ** Update DLYCOB dtaara
      *
     C     *INKI         IFEQ      '1'
     C                   EXSR      #LUPDT
     C                   ENDIF
      *
      ** If F9 pressed from the main screen and no errors, Start
      ** scheduling
      *
     C     *INKI         IFEQ      '1'
     C                   EXSR      #SCSTR
     C                   ENDIF
      *
      ** If F10 pressed from the main screen and no errors, Stop
      ** scheduling
      *
     C     *INKJ         IFEQ      '1'
     C                   EXSR      #SCEND
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Control actual status of scheduling
      *
     C                   EXSR      #LINSC
      *
     C                   ENDDO
      /EJECT
      *****************************************************************
      *                                                               *
      *  #LINIT  -  Initialisation process                            *
      *                                                               *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #LINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      ** Define the local data area
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'CB0004'      DBPGM
     C                   OUT       LDA
      *
      ** Access RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Initialise screen message queue
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      *BLANKS       WWTPGQ           10
     C                   MOVEL     '*'           WWTPGQ
     C                   MOVE      *BLANKS       WWPGQR            5
     C                   MOVEL     '*PRV'        WWPGQR
     C                   MOVE      '1'           *IN76
      *
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'CB0004'      DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     'FIRST'       DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ELSE
     C                   MOVE      '0'           *IN98
     C                   ENDIF
      *
      ** Set up screen header details
      *
     C                   MOVEL     ##PGM         SPGMN
     C                   MOVEL     WJBNB         SWJOB
     C                   MOVEL     WUSER         SUSER
     C                   MOVEL     BJMRDT        SDATE
      *
      ** Retrieve system date
      *
     C                   MOVEL     UDAY          SYSD
     C                   MOVEL     UMONTH        SYSM
     C                   MOVEL     UYEAR         SYSY
     C                   CALL      'ZDATE1'                             90
     C                   PARM                    WQ0028            7
     C                   PARM      SYSN          WQ0029            6 0
     C                   PARM      'D'           WQ0030            1
     C                   PARM                    WQ0031            5 0
     C                   Z-ADD     WQ0031        SYSDAT            5 0
      ** Access SDSTAT
      *
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
      *
     C     KZONE         KLIST
     C                   KFLD                    LIBR
      *
      ** Get Zone Details
      *
     C     KZONE         CHAIN     GPZONEL2                           30
      *
     C     *IN30         IFEQ      *ON
     C                   MOVEL     'CB0004'      DBPGM
     C                   MOVEL     'GPZONEL2'    DBFILE
     C                   MOVEL     LIBR          DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     ZOZONE        WZONE1
     C                   MOVEL     WZONE5        WZONE2
     C     ZOTMDF        IFLT      0
     C                   MOVEL     '-'           WZONE3
     C                   Z-SUB     ZOTMDF        WTDIF             2 0
     C                   ELSE
     C                   MOVEL     '+'           WZONE3
     C                   Z-ADD     ZOTMDF        WTDIF
     C                   ENDIF
     C                   MOVE      WTDIF         WZONE3
     C                   MOVEL     ')'           WZONE4
     C                   MOVEL     ZONEDS        #0ZONE
     C                   MOVEL     POFFST        TMDFDS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #LINTS  -  Initialisation of screen fields                   *
      *                                                               *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #LINTS        BEGSR
      *
      ** Access DLYCOB
      *
     C     *DTAARA       DEFINE                  DLYCOB
     C                   IN        DLYCOB
      *
     C                   MOVEL     AUTSCH        #0AUSC
      *
      ** If blanks default to Midas rundate
      *
     C     SCHDAT        IFEQ      0
     C                   Z-ADD     BJRDNB        SCHDAT
     C                   ENDIF
     C                   CALL      'ZDATE2'                             90
     C                   PARM      SCHDAT        WQ0001            5 0
     C                   PARM      BJDFIN        WQ0002            1
     C                   PARM                    WQ0003            6 0
     C                   PARM                    WQ0004            7
     C                   MOVEL     WQ0003        #0SCDT
     C     2             SUBST     SCHTIM:1      #0SCTH
     C     2             SUBST     SCHTIM:3      #0SCTM
     C                   MOVEL     SCHTMM        #0SCWR
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #LINSC  -  Control actual status of scheduling               *
      *                                                               *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #LINSC        BEGSR
      *
     C                   IN        DLYCOB
      *
      ** Schedule requested
      *
     C     SCHREQ        IFEQ      'Y'
     C                   MOVEA     TEXT(1)       #0SCS1
      *
      ** Control status of schedule COB
      *
     C                   CALL      'CBC0002'                            90
     C                   PARM                    COBNAM
     C                   PARM                    COBUSR
     C                   PARM                    COBNBR
     C                   PARM                    WKSTS            10
     C                   PARM                    WKSTSQ           10
      *
      ** COB job not in jobq or held in jobq
      *
     C     WKSTS         IFNE      '*JOBQ'
     C     WKSTS         OREQ      '*JOBQ'
     C     WKSTSQ        ANDNE     'SCD'
     C                   MOVEA     TEXT(3)       #0SCS2
     C                   ELSE
      *
      ** COB status OK in jobq and scd
      *
     C                   MOVEA     TEXT(2)       #0SCS2
     C                   ENDIF
      *
      ** Schedule not requested
      *
     C                   ELSE
     C                   MOVEA     TEXT(4)       #0SCS1
      *
      ** Schedule date incompatible with system date
      *
     C     SCHDAT        IFLT      SYSDAT
     C                   MOVEA     TEXT(5)       #0SCS2
     C                   ELSE
     C                   MOVEL     *BLANKS       #0SCS2
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #ACJOB  -  Active job checking                               *
      *                                                               *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #ACJOB        BEGSR
      *
     C                   EVAL      WIDX  = 1
     C                   EVAL      WIDX2 = 1
     C                   DO        10            WRRN
      *
     C     WRRN          CHAIN     CBJOBLPD                           95

     C                   IF        %FOUND(CBJOBLPD)
     C                   EVAL      %SUBST(DSJOBS:WIDX:12) = DSJOBF

     C     CBJOBA        IFEQ      'R'
     C                   EVAL      %SUBST(DSJOBA:WIDX2:10) = 'Running'
     C                   ELSE
     C     CBJOBN        IFNE      *BLANKS
     C                   EVAL      %SUBST(DSJOBA:WIDX2:10) = 'Finished'
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDIF
      *
     C                   EVAL      WIDX  = WIDX  + 12
     C                   EVAL      WIDX2 = WIDX2 + 10
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #LVLDS  -  Validate main screen fields                       *
      *  Called by: Main                                              *
      *  Calls    :  ZASNMS                                           *
      *                                                               *
      *****************************************************************
      *
     C     #LVLDS        BEGSR
      *
      ** Initialise Error indicators
      *
     C                   MOVE      '0'           @ERR              1
     C                   MOVEA     '00000'       *IN(11)
     C                   Z-ADD     0             #0HDAT            5 0
      *
      ** Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ** Validate Only if not F10 Stop Scheduling
      *
     C     *INKJ         IFNE      '1'
      *
      ** Validate Automatic Scheduling field
      *
     C     #0AUSC        IFEQ      *BLANKS
     C                   MOVEL     'N'           #0AUSC
     C                   ENDIF
     C     #0AUSC        IFNE      'Y'
     C     #0AUSC        ANDNE     'N'
     C                   MOVEL     'SCH0001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   MOVE      '1'           @ERR
     C                   ENDIF
      *
      ** Validate Scheduling date
      ** If blanks default to system date
      *
     C     #0SCDT        IFEQ      *BLANKS
     C                   CALL      'ZDATE2'                             90
     C                   PARM      SYSDAT        WQ0001            5 0
     C                   PARM      BJDFIN        WQ0002            1
     C                   PARM                    WQ0003            6 0
     C                   PARM                    WQ0004            7
     C                   MOVEL     WQ0003        #0SCDT
     C                   ENDIF
     C                   MOVEL     #0SCDT        WQ0029
     C                   CALL      'ZDATE1'                             90
     C                   PARM                    WQ0028            7
     C                   PARM                    WQ0029            6 0
     C                   PARM      BJDFIN        WQ0030            1
     C                   PARM                    WQ0031            5 0
     C     WQ0028        IFNE      *BLANKS
     C                   MOVEL     'SCH0002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   MOVE      '1'           @ERR
     C                   ELSE
     C*
     C                   Z-ADD     WQ0031        #0HDAT            5 0
     C                   ENDIF
      *
      ** Validate Scheduling time
      *
     C                   CALL      'ZALIGN'                             90
     C                   PARM                    WQ0021            7
     C                   PARM      #0SCTH        WQ0022           16
     C                   PARM      *ZERO         WQ0023            1 0
     C                   PARM      2             WQ0024            2 0
     C                   PARM      *BLANKS       WQ0025           16
     C     WQ0021        IFEQ      *BLANKS
     C                   MOVE      WQ0025        #0SCTH
     C                   ENDIF
     C     #0SCTH        IFLT      '00'
     C     #0SCTH        ORGT      '23'
     C                   MOVEL     'SCH0004'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   MOVE      '1'           @ERR
     C                   ENDIF
     C                   CALL      'ZALIGN'                             90
     C                   PARM                    WQ0021            7
     C                   PARM      #0SCTM        WQ0022           16
     C                   PARM      *ZERO         WQ0023            1 0
     C                   PARM      2             WQ0024            2 0
     C                   PARM      *BLANKS       WQ0025           16
     C     WQ0021        IFEQ      *BLANKS
     C                   MOVE      WQ0025        #0SCTM
     C                   ENDIF
     C     #0SCTM        IFLT      '00'
     C     #0SCTM        ORGT      '59'
     C                   MOVEL     'SCH0004'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN14
     C                   MOVE      '1'           @ERR
     C                   ENDIF
      *
      ** Validate Scheduling date and time
      *
     C     *IN12         IFEQ      '0'
     C     *IN13         ANDEQ     '0'
     C     *IN14         ANDEQ     '0'
      *
      ** Convert time entered to GMT
      *
     C                   MOVE      #0SCTH        WSCTH             2 0
     C     ZOTMDF        IFLT      0
     C                   ADD       WTDIF         WSCTH
     C                   ELSE
     C                   SUB       WTDIF         WSCTH
     C                   ENDIF
      *
      ** Convert the GMT to Local Time
      *
     C     WTMSGN        IFEQ      '-'
     C                   SUB       WHOUR         WSCTH
     C                   ELSE
     C                   ADD       WHOUR         WSCTH
     C                   ENDIF
      *
     C                   Z-ADD     #0HDAT        WHDAT             5 0
      *
      ** Hour more than 24 or equal to 24, add 1 day
      *
     C     WSCTH         IFGE      24
     C                   ADD       1             WHDAT
     C                   SUB       24            WSCTH
     C                   ENDIF
     C                   Z-ADD     WHDAT         SCHDAT
      *
     C                   CALL      'ZDATE2'
     C                   PARM      WHDAT         WQ0001
     C                   PARM      BJDFIN        WQ0002
     C                   PARM                    WQ0003
     C                   PARM                    WQ0004
      *
     C                   MOVEL     WQ0004        #0SCDA
     C                   MOVE      WSCTH         WSCTHC            2
     C                   MOVE      #0SCTM        WSMIN             2
     C     WSCTHC        CAT       ':'           #0SCTI
     C                   MOVE      WSMIN         #0SCTI
     C     WHDAT         IFLT      SYSDAT
     C                   MOVEL     'SCH0003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   MOVE      '1'           @ERR
     C                   ELSE
     C     WSCTHC        CAT       WSMIN         SCTIM             6
     C                   MOVE      '00'          SCTIM
     C                   MOVEL     SCTIM         SCTIMN            6 0
     C                   TIME                    STIME             6 0
     C                   TIME                    #0STIM
     C                   ENDIF
     C     WHDAT         IFEQ      SYSDAT
     C     SCTIMN        ANDLT     STIME
     C                   MOVEL     'SCH0005'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   MOVE      '1'           *IN13
     C                   MOVE      '1'           *IN14
     C                   MOVE      '1'           @ERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Warning period
      *
     C                   CALL      'ZALIGN'                             90
     C                   PARM                    WQ0021            7
     C                   PARM      #0SCWR        WQ0022           16
     C                   PARM      *ZERO         WQ0023            1 0
     C                   PARM      2             WQ0024            2 0
     C                   PARM      *BLANKS       WQ0025           16
     C     WQ0021        IFEQ      *BLANKS
     C                   MOVE      WQ0025        #0SCWR
     C                   ENDIF
     C     #0SCWR        IFEQ      '00'
     C     #0SCWR        OREQ      '  '
     C                   MOVEL     '05'          #0SCWR
     C                   ENDIF
     C     #0SCWR        IFLT      '00'
     C     #0SCWR        ORGT      '59'
     C                   MOVEL     'SCH0006'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN15
     C                   MOVE      '1'           @ERR
     C                   ENDIF
      *
     C                   ENDIF

     C                   EVAL      WIDX = 1
     C                   EVAL      WIDX3 = 11
     C                   EVAL      WIDX4 = 12
     C                   EVAL      DSJINT = '0000000000'
     C                   EVAL      DSJINS = '0000000000'

     C                   DO        10            WRRN

     C                   IF        %SUBST(DSJOBS:WIDX:12) <> *BLANKS
      *
      ** Validate Job Type, valid values are B or I
      *
     C                   IF        %SUBST(DSJOBS:WIDX3:1) <> 'B' AND
     C                             %SUBST(DSJOBS:WIDX3:1) <> 'I'
     C                   EVAL      ZAMSID = 'SCH0007'
     C                   EXSR      ZASNMS
     C                   EVAL      SCRINDT(WRRN) = '1'
     C                   EVAL      @ERR  =  '1'
     C                   ENDIF
      *
      ** Validate Type of Checking, valid values are J or S
      *
     C                   IF        %SUBST(DSJOBS:WIDX4:1) <> 'J' AND
     C                             %SUBST(DSJOBS:WIDX4:1) <> 'S'
     C                   EVAL      ZAMSID = 'SCH0008'
     C                   EXSR      ZASNMS
     C                   EVAL      SCRINDS(WRRN) = '1'
     C                   EVAL      @ERR  =  '1'
     C                   ENDIF
      *
      ** Update job indicators
      *
     C                   MOVEA     DSJINT        *IN(41)
     C                   MOVEA     DSJINS        *IN(51)

     C                   ENDIF

     C                   EVAL      WIDX = WIDX + 12
     C                   EVAL      WIDX3 = WIDX3 + 12
     C                   EVAL      WIDX4 = WIDX4 + 12

     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #LUPDT  -  Update file with the correct values               *
      *                                                               *
      *  Called by: Main program                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #LUPDT        BEGSR
      *
     C     *LOCK         IN        DLYCOB
     C                   MOVEL     #0AUSC        AUTSCH
     C                   MOVEL     #0HDAT        SCHDAT
     C                   MOVEL     SCTIM         SCHTIM
     C                   MOVEL     #0SCWR        SCHTMM
     C                   MOVEL     WUSER         REQUSR
      *
     C                   OUT       DLYCOB
      *
      ** Update Active Jobs
      *
     C                   EVAL      WIDX = 1
     C                   DO        10            WRRN
      *
     C     WRRN          CHAIN     CBJOBLPD                           95

     C                   IF        %FOUND(CBJOBLPD)
     C                   EVAL      DSJOBF = %SUBST(DSJOBS:WIDX:12)
     C                   EVAL      CBJOBA = JOBSTAT(WRRN)
     C                   UPDATE    CBJOBLD0
     C                   ENDIF

     C                   EVAL      WIDX = WIDX + 12
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #JOBST  -  Check Job Status                                  *
      *                                                               *
      *  Called by: Main program                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #JOBST        BEGSR
      *
     C                   MOVEL     *BLANK        PJOBA
      *
     C     PJOBN         IFNE      *BLANKS
      *
     C     WRRN          IFEQ      1
     C                   MOVEL     'Y'           PFRST
     C                   ELSE
     C                   MOVEL     'N'           PFRST
     C                   ENDIF
      *
      ** Check Job Status
      *
     C                   CALL      ACTJOB
     C                   PARM                    PJOBN
     C                   PARM                    PJOBT
     C                   PARM                    PJOBS
     C                   PARM                    PFRST
     C                   PARM                    PJOBA
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #JOBSC  -  Update Screen Job Status                          *
      *                                                               *
      *  Called by: Main program                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #JOBSC        BEGSR
      *
     C                   EVAL      DSJOBA = *BLANKS
     C                   EVAL      WIDX = 1
     C                   EVAL      WIDX2 = 1
     C                   EVAL      WIDX3 = 11
     C                   EVAL      WIDX4 = 12
      *
     C                   DO        10            WRRN
      *
      ** Default Job Type and Type of Checking when blank
      *
     C                   IF        %SUBST(DSJOBS:WIDX:12) <> *BLANKS
     C                   IF        %SUBST(DSJOBS:WIDX3:1) = *BLANKS
     C                   EVAL      %SUBST(DSJOBS:WIDX3:1) = 'B'
     C                   ENDIF
     C                   IF        %SUBST(DSJOBS:WIDX4:1) = *BLANKS
     C                   EVAL      %SUBST(DSJOBS:WIDX4:1) = 'J'
     C                   ENDIF
     C                   ENDIF
      *
      ** Check Job Status
      *
     C                   EVAL      DSJOBP = %SUBST(DSJOBS:WIDX:12)
     C                   EXSR      #JOBST
     C                   EVAL      JOBSTAT(WRRN) = PJOBA

     C     PJOBA         IFEQ      'R'
     C                   EVAL      %SUBST(DSJOBA:WIDX2:10) = 'Running'
     C                   ELSE
     C     PJOBN         IFNE      *BLANKS
     C                   EVAL      %SUBST(DSJOBA:WIDX2:10) = 'Finished'
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      WIDX = WIDX + 12
     C                   EVAL      WIDX2 = WIDX2 + 10
     C                   EVAL      WIDX3 = WIDX3 + 12
     C                   EVAL      WIDX4 = WIDX4 + 12
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #SCSTR  -  Start/Restart COB jobs                            *
      *                                                               *
      *  Called by: Main program                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #SCSTR        BEGSR
      *
      ** Stop previous scheduling if exists + restart a new one
      *
     C                   CALL      'CBC0005'
     C                   PARM      'S'           MODE              1            Mode
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #SCEND  -  Update file with the correct values               *
      *                                                               *
      *  Called by: Main program                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #SCEND        BEGSR
      *
      ** Stop previous scheduling
      *
     C                   CALL      'CBC0005'
     C                   PARM      'E'           MODE
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS    - Send message to program's message queue          *
      *                                                               *
      *  CALLS     - Y2SNMGC                                          *
      *                                                               *
      *  CALLED BY - #LVLDS                                           *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: #LINIT- Initialisation subroutine                 *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C                   ENDSR
**  CPY@
(c) Misys International Banking Systems Ltd. 2016
** TEXT
COB already scheduled
Actual status is OK
Actual status incorrect. Restart or Stop the scheduling
COB not scheduled
Scheduled date incompatible with system date
