     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058830
/*STD *  RPGSQLBND                                                    *                     MD058830
/*EXI *  TEXT('Midas SD Network mescription maintenance subfile')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD2000M - Midas SD Network Description Maintenance           *
      *                                                               *
      *  Function:  This sub-file program allows the user to maintain *
      *             from a list of network descriptions               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058830           Date 01Oct21               *
      *  Prev Amend No. CMG008             Date 20Feb20               *
      *                 CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013             Date 29Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD003             Date 01Jul99               *
      *                 S01459             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  CSD101 - Password Encryption (Recompile)                     *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation (Recompile over new layout*
      *                                      of SDNWRKPD)             *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01459 - Addition of Midas Headerbox.                        *
      *                                                               *
      *****************************************************************
     FSD2000M#  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
      * DSP: Network Description Maintenance
      *
     F*SDNWRKL1* IF   E           K DISK                                                    MD058830
     F**********                           INFDS(INFDS1)                                    MD058830
      * RTV: Message Network Details   Retrieval index
      *
     F*SDNWRKL0* UF A E           K DISK    USROPN                                          MD058830
     F**********                           COMMIT                                           MD058830
      * UPD: Message Network Details   Update index
      *
     FSDFCTLL0  UF   E           K DISK    USROPN
     F                                     COMMIT
      * UPD: Standing Data Controls    Update index
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D @CN             S             25    DIM(6) CTDATA PERRCD(1)              Long constants.
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
      /EJECT
      * Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure.
     D JBDTTM          DS
      * Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file data structure.
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure.
      *
     D*@1DBRC***     E DS                  EXTNAME(SDNWRKL0)                                MD058830
     D @1DBRC        E DS                  EXTNAME(SDNWKJW0)                                MD058830
     D                                     PREFIX(X)                                        MD058830
     D SDNWRK        E DS                  EXTNAME(SDNWKJW0)                                MD058830
      * Current/previous master file format fields for change control.
      *
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
      * Outward parameters
     D PARC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PAFNME                 1     10
      * I :  Long Key
     D  PALKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PADR01                61    310
      * I :  Deleted Data Record Pt2
     D  PADR02               311    560
      * I :  Deleted Data Record Pt3
     D  PADR03               561    810
      * I :  Deleted Data Record Pt4
     D  PADR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PADR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PADR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PADR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PADR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PADR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PADR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PADR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PADR12              2811   3060
      * I :  Last Change Date
     D  PALCD               3061   3063P 0
      * I :  Type of Last Change
     D  PATYLC              3064   3064
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Network
     D  ZA0001                 1      6
      * Message data for 'Key Field Invalid Value'
      * If value in key field
     D  ZA0002                 1      1
      * Network
     D  ZA0003                 2      7
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise and load subfile page.
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested:
     C     W0RSF         DOWEQ     'N'
      * Display screen.
     C                   EXSR      CAEXFM
      * Process response:
      * Exit request: Cancel & exit program.
     C   03              CAS                     ZXEXPG
      * HOME: Request subfile reload.
     C   05              CAS                     FBRQRL
      *   Display next SFL page.
     C   27              CAS                     BBLDSF
      * Process screen input.
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & Load subfile page.
      *================================================================
      * Clear subfile.
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile.
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2NWRK        WZNWRK
     C                   MOVEL     #2NWRK        WZNWRK                         Network
     C     KPOS          KLIST
     C                   KFLD                    EDNWRK                         Network
      * Setup key.
     C                   MOVEL     #2NWRK        EDNWRK                         Network
     C*****KPOS*         SETLL     @EDREJZ                            82        *82=EOF     MD058830
     C**N82*****         READ      @EDREJZ                              9182    *82=EOF     MD058830
     C/EXEC SQL                                                                             MD058830
     C+ close ACursor                                                                       MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
     C/EXEC SQL                                                                             MD058830
     C+ declare ACursor insensitive scroll cursor for                                       MD058830
     C+ select * from SDNWKJW0                                                              MD058830
     C+ where EDNWRK >= :EDNWRK                                                             MD058830
     C+ order by EDNWRK                                                                     MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
     C/EXEC SQL                                                                             MD058830
     C+ open ACursor                                                                        MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
     C/EXEC SQL                                                                             MD058830
     C+ fetch next from ACursor into :SDNWRK                                                MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
     C                   setoff                                       82                    MD058830
     C                   If        SQLCODE = 100                                            MD058830
     C                   seton                                        82                    MD058830
     C                   Endif                                                              MD058830
                                                                                            MD058830
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page.
     C                   EXSR      BBLDSF
      *................................................................
      * If no records found, display error message.
     C   82##RR          IFEQ      *ZERO                                        IF
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI ##RR = *ZERO
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page (write empty page if add mode).
      *================================================================
     C                   SETOFF                                       84        No SFLNXTCHG
      * Re-establish fields in read-ahead record.
     C   27W0PMD         IFNE      'ADD'
     C**N82*****         READP     @EDREJZ                                90    *           MD058830
     C**N82*****         READ      @EDREJZ                                90    *           MD058830
     C                   If        *IN82 = '0'                                              MD058830
     C/EXEC SQL                                                                             MD058830
     C+ fetch prior from ACursor into :SDNWRK                                               MD058830
     C/END-EXEC                                                                             MD058830
     C/EXEC SQL                                                                             MD058830
     C+ fetch next from ACursor into :SDNWRK                                                MD058830
     C/END-EXEC                                                                             MD058830
     C                   Endif                                                              MD058830
     C                   END
      *
      * Setof record error indicators.
     C                   MOVE      *ALL'0'       WKIND0            3
     C                   MOVE      *ALL'1'       WKIND1            3
      * Start at previous highest SFL record reached.
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     *ZERO         ##RROK            5 0
      *................................................................
      * Load next page of SFL:
     C**N82##RROK        DOWLT     ##SFPG                                       DO          MD058830
     C                   DOW       SQLCODE = 0                                              MD058830
     C                             and ##RROK < ##SFPG                                      MD058830
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       87        *
      * Clear SFL fields.
     C                   EXSR      MAIZ#1
      * If change mode, load SFL fields.
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Validate subfile record and calculate derived fields.
     C                   EXSR      DFV2RC
     C                   END
      * Output to subfile.
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
      * Set screen conditioning indicators.
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C     W0PMD         IFNE      'ADD'
     C**********         READ      @EDREJZ                                82    *82=EOF     MD058830
     C/EXEC SQL                                                                             MD058830
     C+ fetch next from ACursor into :SDNWRK                                                MD058830
     C/END-EXEC                                                                             MD058830
     C                   END
     C  N82              END                                                    OD 1 - #SFPG
     C                   SETOFF                                       82                    MD058830
     C                   IF        SQLCODE = 100                                            MD058830
     C                   SETON                                        82                    MD058830
     C                   ENDIF                                                              MD058830
      *................................................................
      * Save highest SFL rec, so load can continue at end point.
     C     ##RR          IFGT      ##RRMX
     C     ##RRMX        ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests.
      *================================================================
      * Set screen conditioning indicators.
     C                   EXSR      GBDSA2
      * Update screen time.
     C                   TIME                    ##TME                          Screen time.
     C     W0HLP         DOUEQ     'N'
      * PUTOVR unless conditioned fields change.
     C                   SETON                                        86
     C     *IN89         IFNE      CAIN89
     C     *IN81         ORNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
      * If help requested, display help text.
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
      * Update job time.
     C                   TIME                    ##JTM                          Job time.
      * Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag.
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input.
      *================================================================
      * Maintain subfile position where possible.
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      *
     C     W0PMD         IFNE      'ADD'
      * Change of position specified?
     C     WZNWRK        CASNE     #2NWRK        FBRQRL                         Network
     C                   END
     C                   END
      * Quit if reload requested.
     C     W0RSF         CABEQ     'Y'           DAEXIT
      *
     C   81              DO
      * No data entered as yet.
     C                   MOVEL     'N'           WKIPIN            1
      * Confirm/update is not defered.
     C                   MOVEL     'N'           W0DCF             1
      * Process subfile records.
     C                   EXSR      DBPRSF
      * If error, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * If data entered.
     C     WKIPIN        IFEQ      'Y'
      * Update DBF from subfile.
     C                   EXSR      EAPRSF
      * If error during update, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END                                                    WKIPIN
     C                   END                                                    OD 81
      *=====Process function keys=====
      * Switch between *ADD/*CHANGE modes.
     C   09              EXSR      FACHMD
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile records.
      *================================================================
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
     C                   EXSR      DCPRSR
     C                   SETOFF                                       87        *
      * Set screen conditioning indicators.
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record.
      *================================================================
      * Setoff error indicators.
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       98        No errors
     C                   SETOFF                                       84        NO SFLNXTCHG
     C     W0PMD         IFEQ      'ADD'
      * Check for null record.
     C                   EXSR      DDNLRC
     C     W0NLR         IFEQ      'Y'
     C                   GOTO      DCEXIT
     C                   END
      * If not null record, continue.
     C                   END
     C                   MOVEL     'Y'           WKIPIN                         Data entered
     C                   SETON                                        84        *SFLNXTCHG
      * If delete request, bypass validation.
     C     #1SEL         IFEQ      'D'
     C                   GOTO      DCEXIT
     C                   END
      * Validate subfile record.
     C                   EXSR      DEV1RC
      * If SFLRCD invalid, note the fact.
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99        Invalid SFLRCD
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DDNLRC        BEGSR
      *================================================================
      * Check for null record.
      *================================================================
     C                   MOVEL     'N'           W0NLR             1
     C     #1NWRK        CABNE     *BLANK        DDEXIT                         Network
     C     #1NETD        CABNE     *BLANK        DDEXIT                         Network Descrip
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record.
      *================================================================
      * USER: Validate subfile record fields
     C                   MOVEL     #1NWRK        WUTQKF                         Test ? in Key F
     C                   MOVEL     #1NWRK        WUIVKF                         If value in key
      *CASE:     WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      @CN(01)                                      *IF
      * Setup message data for message.
     C                   MOVEL     #1NWRK        ZA0001                         Network
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9833      *
      *
     C                   ELSE
      *CASE:     WRK.Test ? in Key Field is Asterisk
     C     WUTQKF        IFEQ      @CN(02)                                      *IF
      * Setup message data for message.
     C                   MOVEL     WUIVKF        ZA0002                         If value in key
     C                   MOVEL     #1NWRK        ZA0003                         Network
      * Send message 'Key Field Invalid Value'
     C                   MOVEL     'USR0849'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9833      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate subfile record relations.
     C                   EXSR      DFV2RC
      * Network required.
     C     #1NWRK        IFEQ      *BLANK                                       IF
     C                   SETON                                        9833      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      * Network Description required.
     C     #1NETD        IFEQ      *BLANK                                       IF
     C                   SETON                                        9834      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate subfile record relations.
      *================================================================
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   EAPRSF        BEGSR
      *================================================================
      * Update DBF from subfile records.
      *================================================================
      * Initialise subfile reload flag.
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   END
      * Process all modified subfile records.
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process modified subfile record.
     C                   EXSR      EBPRSR
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes.
     C                   ROLBK
     C                   ELSE
      * Otherwise COMMIT any DBF changes.
     C                   COMMIT
     C                   END
     C                   MOVEL     *BLANK        #1SEL
      * Set screen conditioning indicators.
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      * If any errors, cancel reload.
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           W0RSF             1
     C                   END
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   EBPRSR        BEGSR
      *================================================================
      * Process modified subfile record.
      *================================================================
      * Set off error indicators.
     C                   MOVEA     WKIND0        *IN(32)                        Clear errors
     C                   SETOFF                                       98        No errors
      *
     C     W0PMD         IFEQ      'ADD'
      * Process add request.
     C     #1SEL         IFNE      'D'
     C                   EXSR      DDNLRC
     C     W0NLR         IFNE      'Y'
     C                   EXSR      ECADRQ
     C                   END
     C                   END
     C                   ELSE
     C     #1SEL         IFEQ      'D'
      * Process delete request.
     C                   EXSR      EDDLRQ
     C                   ELSE
      * Process change request.
     C                   EXSR      EECHRQ
     C                   END
     C                   END
      * If error occurred on update, note the fact.
     C     *IN98         IFEQ      '1'
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     ##RR          ##SFRC               99        Error on update
     C                   END
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request.
      *================================================================
      * USER: Create DBF record
      * Create Network Details - Message Network Details  *
     C                   EXSR      SACRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected.
     C                   MOVEA     WKIND1        *IN(32)                        Screen errors
     C                   SETON                                        98        Format Error
     C                   SETOFF                                       87        Enable entry
     C                   SETON                                        84        SFLNXTCHG
     C                   ELSE
      * DBF Write successful.
     C                   SETON                                        87        Disable entry
     C                   SETOFF                                       84        No SFLNXTCHG
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request.
      *================================================================
      * USER: Delete DBF record
      * Delete Network Details - Message Network Details  *
     C                   EXSR      SCDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful.
     C                   MOVEA     WKIND1        *IN(32)                        Screen errors
     C                   SETON                                        98        Format Error
     C                   SETOFF                                       87        Enable entry
     C                   SETON                                        84        SFLNXTCHG
      * If record altered, reset subfile record.
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF Delete successful.
      * Blank out record and protect from entry.
     C                   EXSR      MAIZ#1
     C                   SETON                                        87        Disable entry
     C                   SETOFF                                       84        No SFLNXTCHG
     C                   MOVEL     'Y'           W0RSF             1            Reload subfile
     C                   END                                                    FI W0RTCD
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request.
      *================================================================
      * USER: Change DBF record
      * Change Network Details - Message Network Details  *
     C                   EXSR      SECHRC
     C     W0RTN         IFNE      *BLANK
      * DBF Update error detected.
     C                   MOVEA     WKIND1        *IN(32)                        Screen errors
     C                   SETON                                        98        Format Error
     C                   SETOFF                                       87        Enable entry
     C                   SETON                                        84        SFLNXTCHG
      * Reset subfile record if changed record.
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF Update successful.
     C                   SETOFF                                       87        Enable entry
     C                   SETOFF                                       84        No SFLNXTCHG
     C                   END                                                    FI W0RTCD
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACHMD        BEGSR
      *================================================================
      * Flip between *ADD and *CHANGE modes.
      *================================================================
     C     W0PMD         IFNE      'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   EXSR      FBRQRL
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload.
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   GADSA1        BEGSR
      *================================================================
      * Set display attributes for Subfile record.
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect keys if change mode or updated record.
     C                   SETON                                        88        *
     C   89
     CANN87              SETOFF                                       88        *
     C                   MOVEL     *IN87         *IN79
     C     W0PMD         IFEQ      @CN(06)                                      *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control.
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise subfile record.
      *================================================================
     C                   MOVEL     *BLANK        #1DBRC                         Previous values
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1NWRK                         Network
     C                   MOVEL     *BLANK        #1NETD                         Network Descrip
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @EDREJZ fields to subfile.
      *================================================================
     C                   Z-ADD     EDLCD         #1LCD                          Last Change Dat
     C                   MOVEL     EDTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     EDNWRK        #1NWRK                         Network
     C                   MOVEL     EDNETD        #1NETD                         Network Descrip
      * Hold current record image for change detection.
     C                   eval      @1DBRC = SDNWRK                                          MD058830
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control.
      *================================================================
     C                   MOVEL     *BLANK        #2NWRK                         Network
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Network Details - Message Network Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @EDREJY
     C                   MOVEL     #1NWRK        EDNWRK                         Network
     C                   MOVEL     #1NETD        EDNETD                         Network Descrip
     C                   Z-ADD     WURDNB        EDLCD                          Last Change Dat
     C                   MOVEL     @CN(03)       EDTYLC                         Type of Last Ch
      *
     C     KLCRSA        KLIST
     C                   KFLD                    EDNWRK                         Network
      * Check for duplicate primary key.
     C*****KLCRSA        SETLL     @EDREJY                                90    *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ SELECT *                                                                            MD058830
     C+ into :SDNWRK                                                                        MD058830
     C+ from SDNWKJW0                                                                       MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C                   SETOFF                                       90                    MD058830
     C                   If        SQLCODE =  0                                             MD058830
     C                   SETON                                        90                    MD058830
     C                   ENDIF                                                              MD058830
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR1538'     W0RTN             7
      * Send message 'Message Network Detail EX'
     C                   MOVEL     'USR1538'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SAEXIT
     C                   END
      *
     C**********         WRITE     @EDREJY                              91      *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ insert into SDNWKBTD                                                                MD058830
     C+ (                                                                                   MD058830
     C+   EDNWRK                                                                            MD058830
     C+  ,EDNETD                                                                            MD058830
     C+  ,EDLCD                                                                             MD058830
     C+  ,EDTYLC                                                                            MD058830
     C+  ,EDPROT                                                                            MD058830
     C+  ,EDM940                                                                            MD058830
     C+  ,EDM941                                                                            MD058830
     C+  ,EDM942                                                                            MD058830
     C+  ,EDM950                                                                            MD058830
     C+  ,EDAMDS                                                                            MD058830
     C+  ,EDENRA                                                                            MD058830
     C+  ,EDRPSR                                                                            MD058830
     C+  ,EDPASS                                                                            MD058830
     C+  ,EDPASN                                                                            MD058830
     C+  ,ED0MXL                                                                            MD058830
     C+  ,ED0DMS                                                                            MD058830
     C+  ,ED0MI1                                                                            MD058830
     C+  ,ED0MI2                                                                            MD058830
     C+  ,ED0MI3                                                                            MD058830
     C+  ,ED0MI4                                                                            MD058830
     C+  ,ED0MI5                                                                            MD058830
     C+  ,ED0MI6                                                                            MD058830
     C+  ,ED1AER                                                                            MD058830
     C+  ,ED1SER                                                                            MD058830
     C+  ,ED1AGS                                                                            MD058830
     C+  ,ED1SGS                                                                            MD058830
     C+  ,ED1AMR                                                                            MD058830
     C+  ,ED1SMR                                                                            MD058830
     C+  ,ED1MXL                                                                            MD058830
     C+  ,ED1GNM                                                                            MD058830
     C+  ,ED1RPL                                                                            MD058830
     C+  ,ED1RSP                                                                            MD058830
     C+  ,ED1MI1                                                                            MD058830
     C+  ,ED1MI2                                                                            MD058830
     C+  ,ED1MI3                                                                            MD058830
     C+  ,ED1MI4                                                                            MD058830
     C+  ,ED1MI5                                                                            MD058830
     C+  ,ED1MI6                                                                            MD058830
     C+  ,ED2AER                                                                            MD058830
     C+  ,ED2SER                                                                            MD058830
     C+  ,ED2AGS                                                                            MD058830
     C+  ,ED2SGS                                                                            MD058830
     C+  ,ED2AMR                                                                            MD058830
     C+  ,ED2SMR                                                                            MD058830
     C+  ,ED2MXL                                                                            MD058830
     C+  ,ED2GNM                                                                            MD058830
     C+  ,ED2FNI                                                                            MD058830
     C+  ,ED2NIM                                                                            MD058830
     C+  ,ED2RPL                                                                            MD058830
     C+  ,ED2RSP                                                                            MD058830
     C+  ,ED2MI1                                                                            MD058830
     C+  ,ED2MI2                                                                            MD058830
     C+  ,ED2MI3                                                                            MD058830
     C+  ,ED2MI4                                                                            MD058830
     C+  ,ED2MI5                                                                            MD058830
     C+  ,ED2MI6                                                                            MD058830
     C+  ,ED5MXL                                                                            MD058830
     C+  ,ED5DMS                                                                            MD058830
     C+  ,EDPFRQ                                                                            MD058830
     C+  ,EDRFNP                                                                            MD058830
     C+  ,EDRFSD                                                                            MD058830
     C+  ,EDRFST                                                                            MD058830
     C+  ,EDRFSS                                                                            MD058830
     C+  ,EDFEXU                                                                            MD058830
     C+  ,EDRPNM                                                                            MD058830
     C+  ,EDTSNM                                                                            MD058830
     C+  ,EDSUID                                                                            MD058830
     C+  ,EDSRVP                                                                            MD058830
     C+  ,EDEXTP                                                                            MD058830
     C+  ,EDTRTP                                                                            MD058830
     C+  ,EDACNF                                                                            MD058830
     C+  ,EDMCNW                                                                            MD058830
     C+  ,ED0F61                                                                            MD058830
     C+  ,ED2F61                                                                            MD058830
     C+  ,ED5F61                                                                            MD058830
     C+  ,EDF86F                                                                            MD058830
     C+  ,EDNOLN                                                                            MD058830
     C+  ,EDNCLN                                                                            MD058830
     C+  ,EDLSEP                                                                            MD058830
     C+  ,EDWTXT                                                                            MD058830
     C+  ,EDTRLN                                                                            MD058830
     C+  ,EDMGLN                                                                            MD058830
     C+  ,EDKLSP                                                                            MD058830
     C+  ,EDEXET                                                                            MD058830
     C+  ,EDEXFM                                                                            MD058830
     C+  ,EDGVCD                                                                            MD058830
     C+  ,EDGVCC                                                                            MD058830
     C+  ,EDFSEP                                                                            MD058830
     C+  ,EDFXTR                                                                            MD058830
     C+  ,EDCONV                                                                            MD058830
     C+  ,EDMODE                                                                            MD058830
     C+ )                                                                                   MD058830
     C+ Values                                                                              MD058830
     C+ (                                                                                   MD058830
     C+   :EDNWRK                                                                           MD058830
     C+  ,:EDNETD                                                                           MD058830
     C+  ,:EDLCD                                                                            MD058830
     C+  ,:EDTYLC                                                                           MD058830
     C+  ,:EDPROT                                                                           MD058830
     C+  ,:EDM940                                                                           MD058830
     C+  ,:EDM941                                                                           MD058830
     C+  ,:EDM942                                                                           MD058830
     C+  ,:EDM950                                                                           MD058830
     C+  ,:EDAMDS                                                                           MD058830
     C+  ,:EDENRA                                                                           MD058830
     C+  ,:EDRPSR                                                                           MD058830
     C+  ,:EDPASS                                                                           MD058830
     C+  ,:EDPASN                                                                           MD058830
     C+  ,:ED0MXL                                                                           MD058830
     C+  ,:ED0DMS                                                                           MD058830
     C+  ,:ED0MI1                                                                           MD058830
     C+  ,:ED0MI2                                                                           MD058830
     C+  ,:ED0MI3                                                                           MD058830
     C+  ,:ED0MI4                                                                           MD058830
     C+  ,:ED0MI5                                                                           MD058830
     C+  ,:ED0MI6                                                                           MD058830
     C+  ,:ED1AER                                                                           MD058830
     C+  ,:ED1SER                                                                           MD058830
     C+  ,:ED1AGS                                                                           MD058830
     C+  ,:ED1SGS                                                                           MD058830
     C+  ,:ED1AMR                                                                           MD058830
     C+  ,:ED1SMR                                                                           MD058830
     C+  ,:ED1MXL                                                                           MD058830
     C+  ,:ED1GNM                                                                           MD058830
     C+  ,:ED1RPL                                                                           MD058830
     C+  ,:ED1RSP                                                                           MD058830
     C+  ,:ED1MI1                                                                           MD058830
     C+  ,:ED1MI2                                                                           MD058830
     C+  ,:ED1MI3                                                                           MD058830
     C+  ,:ED1MI4                                                                           MD058830
     C+  ,:ED1MI5                                                                           MD058830
     C+  ,:ED1MI6                                                                           MD058830
     C+  ,:ED2AER                                                                           MD058830
     C+  ,:ED2SER                                                                           MD058830
     C+  ,:ED2AGS                                                                           MD058830
     C+  ,:ED2SGS                                                                           MD058830
     C+  ,:ED2AMR                                                                           MD058830
     C+  ,:ED2SMR                                                                           MD058830
     C+  ,:ED2MXL                                                                           MD058830
     C+  ,:ED2GNM                                                                           MD058830
     C+  ,:ED2FNI                                                                           MD058830
     C+  ,:ED2NIM                                                                           MD058830
     C+  ,:ED2RPL                                                                           MD058830
     C+  ,:ED2RSP                                                                           MD058830
     C+  ,:ED2MI1                                                                           MD058830
     C+  ,:ED2MI2                                                                           MD058830
     C+  ,:ED2MI3                                                                           MD058830
     C+  ,:ED2MI4                                                                           MD058830
     C+  ,:ED2MI5                                                                           MD058830
     C+  ,:ED2MI6                                                                           MD058830
     C+  ,:ED5MXL                                                                           MD058830
     C+  ,:ED5DMS                                                                           MD058830
     C+  ,:EDPFRQ                                                                           MD058830
     C+  ,:EDRFNP                                                                           MD058830
     C+  ,:EDRFSD                                                                           MD058830
     C+  ,:EDRFST                                                                           MD058830
     C+  ,:EDRFSS                                                                           MD058830
     C+  ,:EDFEXU                                                                           MD058830
     C+  ,:EDRPNM                                                                           MD058830
     C+  ,:EDTSNM                                                                           MD058830
     C+  ,:EDSUID                                                                           MD058830
     C+  ,:EDSRVP                                                                           MD058830
     C+  ,:EDEXTP                                                                           MD058830
     C+  ,:EDTRTP                                                                           MD058830
     C+  ,:EDACNF                                                                           MD058830
     C+  ,:EDMCNW                                                                           MD058830
     C+  ,:ED0F61                                                                           MD058830
     C+  ,:ED2F61                                                                           MD058830
     C+  ,:ED5F61                                                                           MD058830
     C+  ,:EDF86F                                                                           MD058830
     C+  ,:EDNOLN                                                                           MD058830
     C+  ,:EDNCLN                                                                           MD058830
     C+  ,:EDLSEP                                                                           MD058830
     C+  ,:EDWTXT                                                                           MD058830
     C+  ,:EDTRLN                                                                           MD058830
     C+  ,:EDMGLN                                                                           MD058830
     C+  ,:EDKLSP                                                                           MD058830
     C+  ,:EDEXET                                                                           MD058830
     C+  ,:EDEXFM                                                                           MD058830
     C+  ,:EDGVCD                                                                           MD058830
     C+  ,:EDGVCC                                                                           MD058830
     C+  ,:EDFSEP                                                                           MD058830
     C+  ,:EDFXTR                                                                           MD058830
     C+  ,:EDCONV                                                                           MD058830
     C+  ,'B'                                                                               MD058830
     C+ )                                                                                   MD058830
     C/END-EXEC                                                                             MD058830
     C/EXEC SQL                                                                             MD058830
     C+ insert into SDNWKXTD                                                                MD058830
     C+ (                                                                                   MD058830
     C+   EDNWRK                                                                            MD058830
     C+  ,EDNETD                                                                            MD058830
     C+  ,EDLCD                                                                             MD058830
     C+  ,EDTYLC                                                                            MD058830
     C+  ,EDPROT                                                                            MD058830
     C+  ,EDM940                                                                            MD058830
     C+  ,EDM941                                                                            MD058830
     C+  ,EDM942                                                                            MD058830
     C+  ,EDM950                                                                            MD058830
     C+  ,EDAMDS                                                                            MD058830
     C+  ,EDENRA                                                                            MD058830
     C+  ,EDRPSR                                                                            MD058830
     C+  ,EDPASS                                                                            MD058830
     C+  ,EDPASN                                                                            MD058830
     C+  ,ED0MXL                                                                            MD058830
     C+  ,ED0DMS                                                                            MD058830
     C+  ,ED0MI1                                                                            MD058830
     C+  ,ED0MI2                                                                            MD058830
     C+  ,ED0MI3                                                                            MD058830
     C+  ,ED0MI4                                                                            MD058830
     C+  ,ED0MI5                                                                            MD058830
     C+  ,ED0MI6                                                                            MD058830
     C+  ,ED1AER                                                                            MD058830
     C+  ,ED1SER                                                                            MD058830
     C+  ,ED1AGS                                                                            MD058830
     C+  ,ED1SGS                                                                            MD058830
     C+  ,ED1AMR                                                                            MD058830
     C+  ,ED1SMR                                                                            MD058830
     C+  ,ED1MXL                                                                            MD058830
     C+  ,ED1GNM                                                                            MD058830
     C+  ,ED1RPL                                                                            MD058830
     C+  ,ED1RSP                                                                            MD058830
     C+  ,ED1MI1                                                                            MD058830
     C+  ,ED1MI2                                                                            MD058830
     C+  ,ED1MI3                                                                            MD058830
     C+  ,ED1MI4                                                                            MD058830
     C+  ,ED1MI5                                                                            MD058830
     C+  ,ED1MI6                                                                            MD058830
     C+  ,ED2AER                                                                            MD058830
     C+  ,ED2SER                                                                            MD058830
     C+  ,ED2AGS                                                                            MD058830
     C+  ,ED2SGS                                                                            MD058830
     C+  ,ED2AMR                                                                            MD058830
     C+  ,ED2SMR                                                                            MD058830
     C+  ,ED2MXL                                                                            MD058830
     C+  ,ED2GNM                                                                            MD058830
     C+  ,ED2FNI                                                                            MD058830
     C+  ,ED2NIM                                                                            MD058830
     C+  ,ED2RPL                                                                            MD058830
     C+  ,ED2RSP                                                                            MD058830
     C+  ,ED2MI1                                                                            MD058830
     C+  ,ED2MI2                                                                            MD058830
     C+  ,ED2MI3                                                                            MD058830
     C+  ,ED2MI4                                                                            MD058830
     C+  ,ED2MI5                                                                            MD058830
     C+  ,ED2MI6                                                                            MD058830
     C+  ,ED5MXL                                                                            MD058830
     C+  ,ED5DMS                                                                            MD058830
     C+  ,EDPFRQ                                                                            MD058830
     C+  ,EDRFNP                                                                            MD058830
     C+  ,EDRFSD                                                                            MD058830
     C+  ,EDRFST                                                                            MD058830
     C+  ,EDRFSS                                                                            MD058830
     C+  ,EDFEXU                                                                            MD058830
     C+  ,EDRPNM                                                                            MD058830
     C+  ,EDTSNM                                                                            MD058830
     C+  ,EDSUID                                                                            MD058830
     C+  ,EDEXTP                                                                            MD058830
     C+  ,EDTRTP                                                                            MD058830
     C+  ,EDACNF                                                                            MD058830
     C+  ,EDMCNW                                                                            MD058830
     C+  ,ED0F61                                                                            MD058830
     C+  ,ED2F61                                                                            MD058830
     C+  ,ED5F61                                                                            MD058830
     C+  ,EDF86F                                                                            MD058830
     C+  ,EDNOLN                                                                            MD058830
     C+  ,EDNCLN                                                                            MD058830
     C+  ,EDLSEP                                                                            MD058830
     C+  ,EDWTXT                                                                            MD058830
     C+  ,EDTRLN                                                                            MD058830
     C+  ,EDMGLN                                                                            MD058830
     C+  ,EDKLSP                                                                            MD058830
     C+  ,EDEXET                                                                            MD058830
     C+  ,EDEXFM                                                                            MD058830
     C+  ,EDGVCD                                                                            MD058830
     C+  ,EDGVCC                                                                            MD058830
     C+  ,EDFSEP                                                                            MD058830
     C+  ,EDFXTR                                                                            MD058830
     C+  ,EDCONV                                                                            MD058830
     C+  ,EDMODE                                                                            MD058830
     C+ )                                                                                   MD058830
     C+ Values                                                                              MD058830
     C+ (                                                                                   MD058830
     C+   :EDNWRK                                                                           MD058830
     C+  ,:EDNETD                                                                           MD058830
     C+  ,:EDLCD                                                                            MD058830
     C+  ,:EDTYLC                                                                           MD058830
     C+  ,:EDPROT                                                                           MD058830
     C+  ,:EDM940                                                                           MD058830
     C+  ,:EDM941                                                                           MD058830
     C+  ,:EDM942                                                                           MD058830
     C+  ,:EDM950                                                                           MD058830
     C+  ,:EDAMDS                                                                           MD058830
     C+  ,:EDENRA                                                                           MD058830
     C+  ,:EDRPSR                                                                           MD058830
     C+  ,:EDPASS                                                                           MD058830
     C+  ,:EDPASN                                                                           MD058830
     C+  ,:ED0MXL                                                                           MD058830
     C+  ,:ED0DMS                                                                           MD058830
     C+  ,:ED0MI1                                                                           MD058830
     C+  ,:ED0MI2                                                                           MD058830
     C+  ,:ED0MI3                                                                           MD058830
     C+  ,:ED0MI4                                                                           MD058830
     C+  ,:ED0MI5                                                                           MD058830
     C+  ,:ED0MI6                                                                           MD058830
     C+  ,:ED1AER                                                                           MD058830
     C+  ,:ED1SER                                                                           MD058830
     C+  ,:ED1AGS                                                                           MD058830
     C+  ,:ED1SGS                                                                           MD058830
     C+  ,:ED1AMR                                                                           MD058830
     C+  ,:ED1SMR                                                                           MD058830
     C+  ,:ED1MXL                                                                           MD058830
     C+  ,:ED1GNM                                                                           MD058830
     C+  ,:ED1RPL                                                                           MD058830
     C+  ,:ED1RSP                                                                           MD058830
     C+  ,:ED1MI1                                                                           MD058830
     C+  ,:ED1MI2                                                                           MD058830
     C+  ,:ED1MI3                                                                           MD058830
     C+  ,:ED1MI4                                                                           MD058830
     C+  ,:ED1MI5                                                                           MD058830
     C+  ,:ED1MI6                                                                           MD058830
     C+  ,:ED2AER                                                                           MD058830
     C+  ,:ED2SER                                                                           MD058830
     C+  ,:ED2AGS                                                                           MD058830
     C+  ,:ED2SGS                                                                           MD058830
     C+  ,:ED2AMR                                                                           MD058830
     C+  ,:ED2SMR                                                                           MD058830
     C+  ,:ED2MXL                                                                           MD058830
     C+  ,:ED2GNM                                                                           MD058830
     C+  ,:ED2FNI                                                                           MD058830
     C+  ,:ED2NIM                                                                           MD058830
     C+  ,:ED2RPL                                                                           MD058830
     C+  ,:ED2RSP                                                                           MD058830
     C+  ,:ED2MI1                                                                           MD058830
     C+  ,:ED2MI2                                                                           MD058830
     C+  ,:ED2MI3                                                                           MD058830
     C+  ,:ED2MI4                                                                           MD058830
     C+  ,:ED2MI5                                                                           MD058830
     C+  ,:ED2MI6                                                                           MD058830
     C+  ,:ED5MXL                                                                           MD058830
     C+  ,:ED5DMS                                                                           MD058830
     C+  ,:EDPFRQ                                                                           MD058830
     C+  ,:EDRFNP                                                                           MD058830
     C+  ,:EDRFSD                                                                           MD058830
     C+  ,:EDRFST                                                                           MD058830
     C+  ,:EDRFSS                                                                           MD058830
     C+  ,:EDFEXU                                                                           MD058830
     C+  ,:EDRPNM                                                                           MD058830
     C+  ,:EDTSNM                                                                           MD058830
     C+  ,:EDSUID                                                                           MD058830
     C+  ,:EDEXTP                                                                           MD058830
     C+  ,:EDTRTP                                                                           MD058830
     C+  ,:EDACNF                                                                           MD058830
     C+  ,:EDMCNW                                                                           MD058830
     C+  ,:ED0F61                                                                           MD058830
     C+  ,:ED2F61                                                                           MD058830
     C+  ,:ED5F61                                                                           MD058830
     C+  ,:EDF86F                                                                           MD058830
     C+  ,:EDNOLN                                                                           MD058830
     C+  ,:EDNCLN                                                                           MD058830
     C+  ,:EDLSEP                                                                           MD058830
     C+  ,:EDWTXT                                                                           MD058830
     C+  ,:EDTRLN                                                                           MD058830
     C+  ,:EDMGLN                                                                           MD058830
     C+  ,:EDKLSP                                                                           MD058830
     C+  ,:EDEXET                                                                           MD058830
     C+  ,:EDEXFM                                                                           MD058830
     C+  ,:EDGVCD                                                                           MD058830
     C+  ,:EDGVCC                                                                           MD058830
     C+  ,:EDFSEP                                                                           MD058830
     C+  ,:EDFXTR                                                                           MD058830
     C+  ,:EDCONV                                                                           MD058830
     C+  ,'B'                                                                               MD058830
     C+ )                                                                                   MD058830
     C/END-EXEC                                                                             MD058830
      *
     C******IN91         IFEQ      '1'                                                      MD058830
     C     SQLCODE       IFNE      0                                                        MD058830
      *
      * Write error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Write successful.
      * USER: Processing after DBF update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SBCHRC
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVEL     @CN(04)       AHFLNM                         Filename
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSB        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
     C                   UPDATE    @AHREAU                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCDLRC        BEGSR
      *================================================================
      * Delete Network Details - Message Network Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @EDREJY
     C                   MOVEL     #1NWRK        EDNWRK                         Network
      *
     C     KLDLSC        KLIST
     C                   KFLD                    EDNWRK                         Network
     C*****KLDLSC        CHAIN     @EDREJY                            9091      *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ SELECT *                                                                            MD058830
     C+ into :SDNWRK                                                                        MD058830
     C+ from SDNWKJW0                                                                       MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C                   SETOFF                                       90                    MD058830
     C                   If        SQLCODE = 100                                            MD058830
     C                   SETON                                        90                    MD058830
     C                   ENDIF                                                              MD058830
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058830
     C                   SETON                                        91                    MD058830
     C                   ENDIF                                                              MD058830
                                                                                            MD058830
     C     *IN90         IFEQ      '1'
      * Record already deleted.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record.
     C                   eval      @1DBRC = SDNWRK                                          MD058830
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C*****KLDLSC        SETLL     @EDREJY                            9091      *           MD058830
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      * Do no allow deletion of core Network                                                MD058830
     C     EDMODE        IFEQ      'C'                                                      MD058830
     C                   MOVEL     'USR0554'     ZAMSID                                     MD058830
     C                   MOVEL     'USR0554'     W0RTN                                      MD058830
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD058830
     C                   EXSR      ZASNMS                                                   MD058830
     C                   GOTO      SCEXIT                                                   MD058830
     C                   ENDIF                                                              MD058830
                                                                                            MD058830
      *................................................................
     C**********         DELETE    @EDREJY                              91      *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ delete from SDNWKBTD                                                                MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C/EXEC SQL                                                                             MD058830
     C+ delete from SDNWKXTD                                                                MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C******IN91         IFEQ      '1'                                                      MD058830
     C     SQLCODE       IFNE      0                                                        MD058830
      * Delete error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Delete successful.
      * USER: Processing after DBF update
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDNWRKPD'    PAFNME                         File name
     C                   MOVEL     #1NWRK        PALKEY                         Long Key
     C                   MOVEL     WUDR01        PADR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PADR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PADR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PADR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PADR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PADR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PADR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PADR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PADR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PADR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PADR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PADR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     'D'           PATYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0520X'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     1             WUNODL                         No. of Deletes
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SDCHRC
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVEL     @CN(04)       AHFLNM                         Filename
      *
     C     KLCHSD        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSD        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SDEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
     C                   UPDATE    @AHREAU                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Network Details - Message Network Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @EDREJY
     C                   MOVEL     #1NWRK        EDNWRK                         Network
      *
     C     KLCHSE        KLIST
     C                   KFLD                    EDNWRK                         Network
     C*****KLCHSE        CHAIN     @EDREJY                            9091      *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ SELECT *                                                                            MD058830
     C+ into :SDNWRK                                                                        MD058830
     C+ from SDNWKJW0                                                                       MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C                   SETOFF                                       90                    MD058830
     C                   If        SQLCODE = 100                                            MD058830
     C                   SETON                                        90                    MD058830
     C                   ENDIF                                                              MD058830
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058830
     C                   SETON                                        91                    MD058830
     C                   ENDIF                                                              MD058830
                                                                                            MD058830
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      * Check for changed record.
     C                   eval      @1DBRC = SDNWRK                                          MD058830
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C*****KLCHSE        SETLL     @EDREJY                            9091      *           MD058830
     C                   GOTO      SEEXIT
     C                   END                                                    FI #1DBRC
      * Move Non-key fields to @EDREJY
     C                   MOVEL     #1NETD        EDNETD                         Network Descrip
     C                   Z-ADD     WURDNB        EDLCD                          Last Change Dat
     C                   MOVEL     @CN(05)       EDTYLC                         Type of Last Ch
      *
     C**********         UPDATE    @EDREJY                              91      *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ update SDNWKXTD set                                                                 MD058830
     C+   EDNETD = :EDNETD                                                                  MD058830
     C+  ,EDLCD  = :EDLCD                                                                   MD058830
     C+  ,EDTYLC = :EDTYLC                                                                  MD058830
     C+  ,EDPROT = :EDPROT                                                                  MD058830
     C+  ,EDM940 = :EDM940                                                                  MD058830
     C+  ,EDM941 = :EDM941                                                                  MD058830
     C+  ,EDM942 = :EDM942                                                                  MD058830
     C+  ,EDM950 = :EDM950                                                                  MD058830
     C+  ,EDAMDS = :EDAMDS                                                                  MD058830
     C+  ,EDENRA = :EDENRA                                                                  MD058830
     C+  ,EDRPSR = :EDRPSR                                                                  MD058830
     C+  ,EDPASS = :EDPASS                                                                  MD058830
     C+  ,EDPASN = :EDPASN                                                                  MD058830
     C+  ,ED0MXL = :ED0MXL                                                                  MD058830
     C+  ,ED0DMS = :ED0DMS                                                                  MD058830
     C+  ,ED0MI1 = :ED0MI1                                                                  MD058830
     C+  ,ED0MI2 = :ED0MI2                                                                  MD058830
     C+  ,ED0MI3 = :ED0MI3                                                                  MD058830
     C+  ,ED0MI4 = :ED0MI4                                                                  MD058830
     C+  ,ED0MI5 = :ED0MI5                                                                  MD058830
     C+  ,ED0MI6 = :ED0MI6                                                                  MD058830
     C+  ,ED1AER = :ED1AER                                                                  MD058830
     C+  ,ED1SER = :ED1SER                                                                  MD058830
     C+  ,ED1AGS = :ED1AGS                                                                  MD058830
     C+  ,ED1SGS = :ED1SGS                                                                  MD058830
     C+  ,ED1AMR = :ED1AMR                                                                  MD058830
     C+  ,ED1SMR = :ED1SMR                                                                  MD058830
     C+  ,ED1MXL = :ED1MXL                                                                  MD058830
     C+  ,ED1GNM = :ED1GNM                                                                  MD058830
     C+  ,ED1RPL = :ED1RPL                                                                  MD058830
     C+  ,ED1RSP = :ED1RSP                                                                  MD058830
     C+  ,ED1MI1 = :ED1MI1                                                                  MD058830
     C+  ,ED1MI2 = :ED1MI2                                                                  MD058830
     C+  ,ED1MI3 = :ED1MI3                                                                  MD058830
     C+  ,ED1MI4 = :ED1MI4                                                                  MD058830
     C+  ,ED1MI5 = :ED1MI5                                                                  MD058830
     C+  ,ED1MI6 = :ED1MI6                                                                  MD058830
     C+  ,ED2AER = :ED2AER                                                                  MD058830
     C+  ,ED2SER = :ED2SER                                                                  MD058830
     C+  ,ED2AGS = :ED2AGS                                                                  MD058830
     C+  ,ED2SGS = :ED2SGS                                                                  MD058830
     C+  ,ED2AMR = :ED2AMR                                                                  MD058830
     C+  ,ED2SMR = :ED2SMR                                                                  MD058830
     C+  ,ED2MXL = :ED2MXL                                                                  MD058830
     C+  ,ED2GNM = :ED2GNM                                                                  MD058830
     C+  ,ED2FNI = :ED2FNI                                                                  MD058830
     C+  ,ED2NIM = :ED2NIM                                                                  MD058830
     C+  ,ED2RPL = :ED2RPL                                                                  MD058830
     C+  ,ED2RSP = :ED2RSP                                                                  MD058830
     C+  ,ED2MI1 = :ED2MI1                                                                  MD058830
     C+  ,ED2MI2 = :ED2MI2                                                                  MD058830
     C+  ,ED2MI3 = :ED2MI3                                                                  MD058830
     C+  ,ED2MI4 = :ED2MI4                                                                  MD058830
     C+  ,ED2MI5 = :ED2MI5                                                                  MD058830
     C+  ,ED2MI6 = :ED2MI6                                                                  MD058830
     C+  ,ED5MXL = :ED5MXL                                                                  MD058830
     C+  ,ED5DMS = :ED5DMS                                                                  MD058830
     C+  ,EDPFRQ = :EDPFRQ                                                                  MD058830
     C+  ,EDRFNP = :EDRFNP                                                                  MD058830
     C+  ,EDRFSD = :EDRFSD                                                                  MD058830
     C+  ,EDRFST = :EDRFST                                                                  MD058830
     C+  ,EDRFSS = :EDRFSS                                                                  MD058830
     C+  ,EDFEXU = :EDFEXU                                                                  MD058830
     C+  ,EDRPNM = :EDRPNM                                                                  MD058830
     C+  ,EDTSNM = :EDTSNM                                                                  MD058830
     C+  ,EDSUID = :EDSUID                                                                  MD058830
     C+  ,EDEXTP = :EDEXTP                                                                  MD058830
     C+  ,EDTRTP = :EDTRTP                                                                  MD058830
     C+  ,EDACNF = :EDACNF                                                                  MD058830
     C+  ,EDMCNW = :EDMCNW                                                                  MD058830
     C+  ,ED0F61 = :ED0F61                                                                  MD058830
     C+  ,ED2F61 = :ED2F61                                                                  MD058830
     C+  ,ED5F61 = :ED5F61                                                                  MD058830
     C+  ,EDF86F = :EDF86F                                                                  MD058830
     C+  ,EDNOLN = :EDNOLN                                                                  MD058830
     C+  ,EDNCLN = :EDNCLN                                                                  MD058830
     C+  ,EDLSEP = :EDLSEP                                                                  MD058830
     C+  ,EDWTXT = :EDWTXT                                                                  MD058830
     C+  ,EDTRLN = :EDTRLN                                                                  MD058830
     C+  ,EDMGLN = :EDMGLN                                                                  MD058830
     C+  ,EDKLSP = :EDKLSP                                                                  MD058830
     C+  ,EDEXET = :EDEXET                                                                  MD058830
     C+  ,EDEXFM = :EDEXFM                                                                  MD058830
     C+  ,EDGVCD = :EDGVCD                                                                  MD058830
     C+  ,EDGVCC = :EDGVCC                                                                  MD058830
     C+  ,EDFSEP = :EDFSEP                                                                  MD058830
     C+  ,EDFXTR = :EDFXTR                                                                  MD058830
     C+  ,EDCONV = :EDCONV                                                                  MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C                   SETOFF                                       91                    MD058830
     C                   If        SQLCODE <> 0                                             MD058830
     C                   SETON                                        91                    MD058830
     C                   ENDIF                                                              MD058830
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
      * Update saved record image.
     C                   MOVEL     @1DBRC        #1DBRC
      * USER: Processing after DBF update
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SFCHRC
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVEL     @CN(04)       AHFLNM                         Filename
      *
     C     KLCHSF        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSF        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SFEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
     C                   UPDATE    @AHREAU                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
      * If no message file specified use default.
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      * Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text.
      *================================================================
     C                   MOVEL     'Y'           W0HLP             1            Signal help req
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Member name.
     C                   PARM      *BLANK        YYHPFL           10            *DFT text file.
     C                   PARM      *BLANK        YYHPLB           10            Help text lib.
     C                   PARM                    W0RTN             7            Return Code.
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal.
      *================================================================
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
      * ROLLBACK any uncommitted DBF changes.
     C                   ROLBK                                          90
      *
      * Terminate program.
     C                   SETON                                        LR
      *
      * Exit program.
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation.
      *================================================================
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
      * Obtain default message file.
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field Deleted Data Record Pt1
     C                   MOVEL     *BLANK        WUDR01          250
      * Define work field Deleted Data Record Pt2
     C                   MOVEL     *BLANK        WUDR02          250
      * Define work field Deleted Data Record Pt3
     C                   MOVEL     *BLANK        WUDR03          250
      * Define work field Deleted Data Record Pt4
     C                   MOVEL     *BLANK        WUDR04          250
      * Define work field Deleted Data Record Pt5
     C                   MOVEL     *BLANK        WUDR05          250
      * Define work field Deleted Data Record Pt6
     C                   MOVEL     *BLANK        WUDR06          250
      * Define work field Deleted Data Record Pt7
     C                   MOVEL     *BLANK        WUDR07          250
      * Define work field Deleted Data Record Pt8
     C                   MOVEL     *BLANK        WUDR08          250
      * Define work field Deleted Data Record Pt9
     C                   MOVEL     *BLANK        WUDR09          250
      * Define work field Deleted Data Record Pt10
     C                   MOVEL     *BLANK        WUDR00          250
      * Define work field Deleted Data Record Pt11
     C                   MOVEL     *BLANK        WUDR11          250
      * Define work field Deleted Data Record Pt12
     C                   MOVEL     *BLANK        WUDR12          250
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Open files.
      * Begin commit control.
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C**********         OPEN      SDNWRKL0                                                 MD058830
     C                   OPEN      SDFCTLL0
      *
     C                   Z-ADD     15            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
     C                   Z-ADD     *ZERO         ##RRMX                         MAX RECNO
      *................................................................
      * If member empty, set to *ADD mode, else to *CHANGE mode.
     C     @1NROP        IFEQ      *ZERO
     C                   MOVEL     'ADD'         W0PMD             3            Add mode
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD                          Change mode
     C                   END
      * USER: Initialise program
      * Standard RPG Creation PAR - Standard Functions  *
      * Copyright Statement - Standard Functions  *
      * Last amend box SD2000 - Message Network Details  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Initialise subfile control.
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA @CN
?
*
I
SDNWRKPD
A
ADD
