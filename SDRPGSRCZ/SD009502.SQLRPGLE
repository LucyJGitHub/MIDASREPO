     H DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD System Value validation reference maint')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009502 - Midas SD System Value validation reference maint  *
      *                                                               *
      *  Function:  This program allows user to enquire/maintain      *
      *             the validation reference for  System Value.       *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD054605 *CREATE   Date 17Oct19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *                                                               *
     F*****************************************************************
     FSD009502DFCF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
      *
     D AEMQ            S             78    DIM(2) CTDATA PERRCD(1)
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*Edit Report Components   Initialise Program E-Spec
     D @CN             S             25    DIM(11) CTDATA PERRCD(1)             Long constants.
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

     D SDSVRF        E DS                  EXTNAME(SDSVRJW0)
     D SDSVRF2       E DS                  EXTNAME(SDSVRJW0)
     D                                     PREFIX(Y)
     D NullIndsR       s              5i 0 dim(6)
      *
      *
     D @1DBRC        E DS                  EXTNAME(SDSVRJW0)
     D                                     PREFIX(X)
      * Current/previous master file format fields for change control.
      *
     D SDSVAL        E DS                  EXTNAME(SDSVLJW1)
     D SDSVALL       E DS                  EXTNAME(SDSVLJW0)
     D                                     PREFIX(L)
     D NullInds        s              5i 0 dim(21)
     D NullIndsL       s              5i 0 dim(18)
     D DSSEQ           DS
     D  SEQCHAR                1      3
     D  SEQNUM                 1      3  0

     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      /EJECT
      * Parameter declarations.
     D P1PARM          DS            20
      * KEY: Report Components         Retrieval index
      * I:RST Report name
     D  P1SVAL                 1     20
     D P2PARM          DS
      * I:    Action Code
     D  P2JTST                 1      1
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM
     C     P2JTST        PARM                    WP0001            1
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
     C*                  SETON                                        80
     C                   WRITE     #SFLCTL
     C*                  SETOFF                                       80
      * Reset no of records in subfile.
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 8
      * USER: Initialise subfile header
     C                   MOVEL     *BLANK        #2DESC
      * Get validation ref
     C                   EXSR      SARVGN
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #1HDER        WZHDER
     C                   MOVEL     #1HDER        WZHDER
     C     KPOS          KLIST
     C                   KFLD                    GJSVAL
     C                   KFLD                    GJSEQ
     C                   KFLD                    GJVDTA
      * Setup key.
     C                   MOVEL     #2SVAL        GJSVAL
     C                   MOVEL     #1HDER        GJVDTA
     C     KRST          KLIST
     C                   KFLD                    GJSVAL
      * Setup key.
     C                   MOVEL     #2SVAL        GJSVAL
     C                   MOVEL     *BLANKS       SSEQ              3
     C/EXEC SQL
     C+ declare ACursor insensitive scroll cursor for
     C+ select * from SDSVRJW0
     C+ where GJSVAL = :#2SVAL and GJRECI = 'D'
     C/END-EXEC

     C/EXEC SQL
     C+ open ACursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from ACursor into :SDSVRF :NullIndsR
     C/END-EXEC
     C                   If        SQLCODE = 100
     C                   SETON                                        82
     C                   Else
     C                   SETOFF                                       82
     C                   ENDIF

     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page.
     C                   EXSR      BBLDSF
      * If no records, switch to add mode and load again.
     C     W0APM         IFEQ      'Y'                                          First time
     C     ##RR          ANDEQ     *ZERO                                        No records
     C                   MOVEL     'ADD'         W0PMD
     C                   SETOFF                                       82        * Not EOF
     C                   EVAL      SQLCODE = 0
     C                   EXSR      BBLDSF
     C                   END                                                    FI W0APM
     C                   MOVEL     'N'           W0APM             1            Not first time
      *................................................................
      * If no records found, display error message.
     C   82##RR          IFEQ      *ZERO                                        IF
      * Send message '*No data to display'
     C                   MOVEL     'USR7605'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
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
     C                   If        *IN82 = '0'
     C/EXEC SQL
     C+ fetch prior from ACursor into :SDSVRF :NullIndsR
     C/END-EXEC
     C/EXEC SQL
     C+ fetch next from ACursor into :SDSVRF :NullIndsR
     C/END-EXEC
     C                   Endif
     C                   END
      *
      * Setof record error indicators.
     C                   MOVE      *ALL'0'       WKIND0            9
     C                   MOVE      *ALL'1'       WKIND1            9
      * Start at previous highest SFL record reached.
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     *ZERO         ##RROK            5 0
      *................................................................
      * Load next page of SFL:
     C     SQLCODE       DOWEQ     0                                            DO
     C     ##RROK        ANDLT     ##SFPG                                       DO
     C                   MOVEA     WKIND0        *IN(33)
     C                   SETOFF                                       87        *
      * Clear SFL fields.
     C                   EXSR      MAIZ#1
      * If change mode, load SFL fields.
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Calculate function fields.
     C                   EXSR      DG#2FN
      * Record will be selected unless overridden.
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Initialise subfile record (existing record)
     C*
     C** SPLIT PARAMETERS FOR SCREEN
     C*
      *CASE:     PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      @CN(01)                                      *IF
     C                   MOVEL     @CN(02)       WUJTST                         Action Code
     C                   END                                                    *FI
      *
      * If record dropped...
     C     W0RSL         CABNE     'Y'           BB020
      * Validate subfile record and calculate derived fields.
     C                   EXSR      DFV2RC
     C                   ELSE
      * USER: Initialise subfile record (new record)
     C                   MOVEL     P1SVAL        #1SVAL                         Report name
      *CASE:     PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      @CN(04)                                      *IF
     C                   MOVEL     @CN(05)       WUJTST                         Action Code
     C                   END                                                    *FI
     C                   END
      * Output to subfile.
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
      * Set screen conditioning indicators.
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C     BB020         TAG
     C     W0PMD         IFNE      'ADD'
     C/EXEC SQL
     C+ fetch next from ACursor into :SDSVRF :NullIndsR
     C/END-EXEC
     C                   END
     C  N82              END                                                    OD 1 - #SFPG
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
      * CALC: Subfile control function fields
     C                   MOVEL     *BLANK        #2DESC
     C                   MOVE      'N'           SFCHGD            1
     C*                                                                   8
     C                   EXSR      SBRVGN
      *CASE:     PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      @CN(04)                                      *IF
     C                   MOVEL     @CN(05)       WUJTST                         Action Code
     C                   END                                                    *FI
      *CASE:     PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      @CN(01)                                      *IF
     C                   MOVEL     @CN(02)       WUJTST                         Action Code
     C                   END                                                    *FI
     C     W0PMD         IFNE      'ADD'
     C                   END
      * USER: Validate subfile control
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
     C     *IN12         IFEQ      '0'                                          *IF
      * Check Sys Value exist -
     C                   EXSR      SCRVGN
      *CASE:     PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      @CN(06)                                      *IF
      * Send message 'Report component must ext'
     C                   MOVEL     'RCF0051'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   ELSE
      *CASE:     WRK.Update Made is Update Made
     C     WUAZST        IFEQ      @CN(07)                                      *IF
      * Set last change date/type - Report Descriptions  *
     C                   EXSR      SDRVGN
     C                   MOVEL     *BLANK        P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END
     C                   END
     C                   ELSE
     C                   MOVEL     *BLANKS       P0RTN
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
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
     C*                                                                   8
     C** ALLOW EXIT IF SFLRCD HAS NOT BEEN CHANGED                        8
     C*                                                                   8
     C     SFCHGD        IFEQ      'N'
     C     *IN12         ANDEQ     '0'
     C*                                                                   8
      * Check components exist - Report Components  *                     8
     C                   EXSR      SCRVGN
      *CASE:     PGM.*Return code is *Record does not exist               8
     C     W0RTN         IFEQ      @CN(06)                                      *IF
      * Send message 'Report component must ext'                          8
     C                   MOVEL     'RCF0051'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
     C                   ELSE
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
     C                   END
     C*                                                                   8
     C                   END
     C*                                                                   8
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record.
      *================================================================
      * Setoff error indicators.
     C                   MOVEA     WKIND0        *IN(33)
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
     C     #1VDT1        CABNE     *BLANK        DDEXIT                         Mandatory/On Re
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record.
      *================================================================
     C                   MOVE      'Y'           SFCHGD
      * For first record only, validate header
      * Header is mandatory
     C     #1HDER        IFEQ      *BLANKS
     C     ##RR          ANDEQ     1
     C                   SETON                                        9831
     C                   MOVEL     'USR7984'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      * Header must be one of this value
     C     #1HDER        IFNE      '*VALUES'
     C     #1HDER        ANDNE     '*RANGE'
     C     #1HDER        ANDNE     '*EXISTS'
     C     #1HDER        ANDNE     '*PROGRAM'
     C     #1HDER        ANDNE     '*EXISTLIB'
     C     #1HDER        ANDNE     '*EXSTOLIB'
     C     #1HDER        ANDNE     *BLANKS
     C                   SETON                                        9831
     C                   MOVEL     'USR7985'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      * Save Header
     C                   MOVEL     #1HDER        HEADER           10
     C                   ENDIF
     C                   ENDIF

      * If *VALUES or *RANGE, validate that at least the first one is not blank
     C     #1HDER        IFEQ      '*VALUES'
     C     #1HDER        OREQ      '*RANGE'
     C     #1VDT1        IFEQ      *BLANKS
     C                   SETON                                        9833
     C                   MOVEL     'USR7986'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      * For second record
     C     ##RR          IFEQ      2
      * If *RANGE
     C     #1HDER        IFEQ      '*RANGE'
     C     #1VDT1        IFEQ      *BLANKS
     C                   SETON                                        9833
     C                   MOVEL     'USR7987'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate subfile record relations.
      *================================================================
      * Calculate function fields.
     C                   EXSR      DG#2FN
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   DG#2FN        BEGSR
      *================================================================
      * Calculate subfile record fucntion fields.
      *================================================================
      *================================================================
     CSR   DGEXIT        ENDSR
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
     C*                  MOVEL     *BLANK        #1SEL
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
     C                   MOVEA     WKIND0        *IN(33)                        Clear errors
     C                   SETOFF                                       98        No errors
      *
     C     W0PMD         IFEQ      'ADD'
      * Process add request.
     C     P2JTST        IFNE      'D'
     C                   EXSR      DDNLRC
     C     W0NLR         IFNE      'Y'
     C                   EXSR      ECADRQ
     C                   END
     C                   END
     C                   ELSE
     C     P2JTST        IFEQ      'D'
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
     C                   ELSE
      * USER: Extra processing after DBF update
     C                   MOVEL     @CN(07)       WUAZST                         Update Made
     C                   MOVEL     @CN(07)       W0RSF                          *Reload subfile
     C*Report Components edit   Extra Processing Aft Upd
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request.
      *================================================================
      * USER: Create DBF record
     C                   EXSR      SGCRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected.
     C                   MOVEA     WKIND1        *IN(33)                        Screen errors
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
      * Delete Report Components - Report Components  *
     C                   EXSR      SHDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful.
     C                   MOVEA     WKIND1        *IN(33)                        Screen errors
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
      * Change Report Components - Report Components  *
     C                   EXSR      SICHRC
     C     W0RTN         IFNE      *BLANK
      * DBF Update error detected.
     C                   MOVEA     WKIND1        *IN(33)                        Screen errors
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
     C     W0PMD         IFEQ      @CN(04)                                      *IF
     C                   MOVEL     '1'           *IN79
     C                   MOVEL     '0'           *IN31
     C                   MOVEL     '0'           *IN33
     C                   MOVEL     '0'           *IN34
     C                   MOVEL     '0'           *IN35
     C                   MOVEL     '0'           *IN36
     C                   END                                                    *FI
     C                   MOVEL     *IN87         *IN78
     C     WUMBIN        IFEQ      @CN(11)                                      *IF
     C                   MOVEL     '1'           *IN78
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
     C                   MOVEL     P1SVAL        #1SVAL                         Report name
     C                   MOVEL     *BLANK        #1VDT1                         Calling Paramet
     C                   MOVEL     *BLANK        #1VDT2                         Calling Paramet
     C                   MOVEL     *BLANK        #1VDT3                         Calling Paramet
     C                   MOVEL     *BLANK        #1VDT4                         Calling Paramet
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move SDSVR_TD fields to subfile.
      *================================================================
     C                   MOVEL     GJSVAL        #1SVAL                         Report name
     C                   if        GJRECI = 'D'
     C                   eval      #1HDER = *blanks
     C                   eval      #1VDT1 = %subst(GJVDTA:1:50)
     C                   eval      #1VDT2 = %subst(GJVDTA:51:50)
     C                   eval      #1VDT3 = %subst(GJVDTA:101:50)
     C                   eval      #1VDT4 = %subst(GJVDTA:151:50)
     C                   endif
     C                   if        GJSEQ <> SSEQ
     C                   MOVEL     GJSEQ         WSEQ              3
     C/EXEC SQL
     C+ SELECT *
     C+ into :SDSVRF2 :NullInds
     C+ from SDSVRJW0
     C+ where GJSVAL = :#1SVAL and GJRECI = 'H' and GJSEQ = :WSEQ
     C/END-EXEC
     C                   eval      SSEQ = YGJSEQ
     C                   eval      #1HDER = %subst(YGJVDTA:1:10)
     C                   ENDIF
      * Hold current record image for change detection.
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control.
      *================================================================
     C                   MOVEL     P1SVAL        #2SVAL                         Report name
     C                   MOVEL     *BLANK        #1HDER                         Component Name
      * Check restriction within Report Descriptions.
     C                   EXSR      VACKRL
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Get report description - Report Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C/EXEC SQL
     C+ SELECT *
     C+ into :SDSVAL :NullInds
     C+ from SDSVLJW1
     C+ where GISVAL = :P1SVAL
     C/END-EXEC
     C                   IF        SQLCODE = 100
     C                   SETON                                        90
     C                   ELSE
     C                   SETOFF                                       90
     C                   ENDIF
      * DBF Record not found.
     C   90              MOVEL     'USR4616'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   MOVEL     GIDESC        #2DESC
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Get report description - Report Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C/EXEC SQL
     C+ SELECT *
     C+ into :SDSVAL :NullInds
     C+ from SDSVLJW1
     C+ where GISVAL = :P1SVAL
     C/END-EXEC
     C                   IF        SQLCODE = 100
     C                   SETON                                        90
     C                   ELSE
     C                   SETOFF                                       90
     C                   ENDIF
      * DBF Record not found.
     C   90              MOVEL     'USR4616'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   MOVEL     GIDESC        #2DESC                         Report Descript
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Check components exist - Report Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields.
     C     *LIKE         DEFINE    GJSVAL        WQSC01                         Report name
      * Define Keylist.
     C     KPSSC         KLIST
     C                   KFLD                    WQSC01                         Report name
     C                   KFLD                    GJVDTA                         Component Name
      * Define Keylist.
     C     KRSSC         KLIST
     C                   KFLD                    WQSC01                         Report name
      * Move fields to key list.
     C                   MOVEL     P1SVAL        WQSC01                         Report name
     C                   MOVEL     *BLANK        GJVDTA                         Component Name
      *
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDRVGN        BEGSR
      *================================================================
      * Set last change date/type - Report Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C/EXEC SQL
     C+ SELECT *
     C+ into :SDSVALL :NullIndsL
     C+ from SDSVLJW0
     C+ where GISVAL = :P1SVAL
     C/END-EXEC
     C                   IF        SQLCODE = 100
     C                   SETON                                        90
     C                   ELSE
     C                   SETOFF                                       90
     C                   ENDIF
      * DBF Record not found.
     C   90              MOVEL     'USR4616'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
     C                   MOVEL     @CN(02)       WUJTST                         Action Code
      * Change Report Description - Report Descriptions  *
     C                   EXSR      SECHRC
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Report Description - Report Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      *CASE:     PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   MOVEL     @CN(08)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      *CASE:     PGM.*Return code is *Previous Screen
     C     W0RTN         IFEQ      @CN(09)                                      *IF
     C                   GOTO      SEEXIT                                       *QUIT
     C                   END                                                    *FI
      *
     C*    KLCHSE        KLIST
     C*                  KFLD                    DXSVAL                         Report name
     C                   MOVEL     GISVAL        KKSVAL           10            Report name
     C/EXEC SQL
     C+ SELECT *
     C+ into :SDSVAL
     C+ from SDSVLJW0
     C+ where GISVAL = :KKSVAL
     C/END-EXEC
     C                   IF        SQLCODE = 100
     C                   SETON                                        90
     C                   ELSE
     C                   SETOFF                                       90
     C                   ENDIF
      *
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0
     C                   SETON                                        91
     C                   ELSE
     C                   SETOFF                                       90
     C                   ENDIF
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
     C                   MOVEL     'RCF1084'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
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
     C                   MOVEL     @CN(02)       XXCHTP            1            Type of Last
      *
     C                   IF        GIMODE = 'B'
     C/EXEC SQL
     C+ update SDSVLXTD
     C+  SET GILCT  = :XXCHTP
     C+ , GILCD = :WURUND
     C+ WHERE GISVAL = :KKSVAL
     C/END-EXEC

     C                   ENDIF

      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
      /EJECT
     CSR   SGCRRC        BEGSR
      *================================================================
      * Create System Value Validation Reference records
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     #1SVAL        GJSVAL                         Report name
     C*                  MOVEL     #1HDER        GJVDTA                         Component Name
     C                   MOVEL     #1VDT1        GJVDTA                         Mandatory/On Re
      *
     C                   IF        ##RR = 1
      * Initialize sequence to 001
     C                   Z-ADD     1             SEQNUM
      * First create Header record
      * Check that header record does not exist
     C/EXEC SQL
     C+ SELECT *
     C+ into :SDSVRF
     C+ from SDSVRJW0
     C+ where GJSVAL = :#1SVAL and GJRECI ='H'
     C/END-EXEC
     C     SQLCODE       IFEQ      0
     C                   MOVEL     'USR7986'     W0RTN
     C                   MOVEL     'USR7986'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SGEXIT
     C                   END

      * Write header record
     C/EXEC SQL
     C+ insert into SDSVRBTD
     C+ (
     C+   GJRECI
     C+ , GJSVAL
     C+ , GJSEQ
     C+ , GJVDTA
     C+ , GJDESC
     C+ , GJMODE
     C+ )
     C+ Values
     C+ (
     C+   'H'
     C+ , :#1SVAL
     C+ , :SEQCHAR
     C+ , :#1HDER
     C+ , :GIDESC
     C+ , 'B'
     C+ )
     C/END-EXEC

     C/EXEC SQL
     C+ insert into SDSVRXTD
     C+ (
     C+   GJSVAL
     C+ , GJSEQ
     C+ , GJVDTA
     C+ )
     C+ Values
     C+ (
     C+   :#1SVAL
     C+ , :SEQCHAR
     C+ , :#1HDER
     C+ )
     C/END-EXEC
      *
      * save header
     C                   MOVEL     #1HDER        SHDER            10
     C     SQLCODE       IFNE      0
      * Write error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ENDIF
     C                   ENDIF

     C                   IF        ##RR > 1
     C                             and #1HDER <> SHDER
     C                             and #1HDER <> *BLANKS
      * then increment sequence and write new header
     C                   ADD       1             SEQNUM
      * save header
     C                   MOVEL     #1HDER        SHDER            10
      * Write header record
     C/EXEC SQL
     C+ insert into SDSVRBTD
     C+ (
     C+   GJRECI
     C+ , GJSVAL
     C+ , GJSEQ
     C+ , GJVDTA
     C+ , GJDESC
     C+ , GJMODE
     C+ )
     C+ Values
     C+ (
     C+   'H'
     C+ , :#1SVAL
     C+ , :SEQCHAR
     C+ , :#1HDER
     C+ , :GIDESC
     C+ , 'B'
     C+ )
     C/END-EXEC

     C/EXEC SQL
     C+ insert into SDSVRXTD
     C+ (
     C+   GJSVAL
     C+ , GJSEQ
     C+ , GJVDTA
     C+ )
     C+ Values
     C+ (
     C+   :#1SVAL
     C+ , :SEQCHAR
     C+ , :#1HDER
     C+ )
     C/END-EXEC
      *
     C     SQLCODE       IFNE      0
      * Write error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ENDIF
     C                   ENDIF
      * then write detail record (for ##RR = 1 too)
     C/EXEC SQL
     C+ insert into SDSVRBTD
     C+ (
     C+   GJRECI
     C+ , GJSVAL
     C+ , GJSEQ
     C+ , GJVDTA
     C+ , GJDESC
     C+ , GJMODE
     C+ )
     C+ Values
     C+ (
     C+   'D'
     C+ , :#1SVAL
     C+ , :SEQCHAR
     C+ , :#1VDT1 CONCAT :#1VDT2 CONCAT :#1VDT3 CONCAT :#1VDT4
     C+ , :GIDESC
     C+ , 'B'
     C+ )
     C/END-EXEC

     C/EXEC SQL
     C+ insert into SDSVRXTD
     C+ (
     C+   GJSVAL
     C+ , GJSEQ
     C+ , GJVDTA
     C+ )
     C+ Values
     C+ (
     C+   :#1SVAL
     C+ , :SEQCHAR
     C+ , :#1VDT1 CONCAT :#1VDT2 CONCAT :#1VDT3 CONCAT :#1VDT4
     C+ )
     C/END-EXEC
     C     SQLCODE       IFNE      0
      * Write error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ENDIF
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHDLRC        BEGSR
      *================================================================
      * Delete Report Components - Report Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before DBF update
      *
      * Move key fields to @SARML2
     C                   MOVEL     #1SVAL        KSVAL            10                           S0140
     C*                  MOVEL     #1HDER        KHDER            10                           S0140
      *
     C     KSARM         KLIST                                                                 S0140
     C                   KFLD                    KSVAL                                         S0140
     C*                  KFLD                    KHDER                                         S0140
      *
     C                   MOVEL     #1SVAL        GJSVAL                         Report name
     C*                  MOVEL     #1HDER        GJVDTA                         Component Name
      *
     C     KLDLSH        KLIST
     C                   KFLD                    GJSVAL                         Report name
     C                   KFLD                    GJVDTA                         Component Name
     C     *IN90         IFEQ      '1'
      * Record already deleted.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C**********           MOVEL'Y2U0009' ZAMSID           Message id.    2
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  2
     C                   MOVEL     'RCF1084'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SHEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SHEXIT
     C                   END
      *
      * Check for changed record.
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C**********           MOVEL'Y2U0007' ZAMSID           Message id.    2
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  2
     C                   MOVEL     'RCF1085'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C                   GOTO      SHEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C     *IN91         IFEQ      '1'
      * Delete error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Delete successful.
      *
      * If Report Component is related to a switchable feature, delete
      * records from Switchable Features Report Component file
      *
     C*    AESARN        IFNE      *BLANKS                                                     S0140
     C*    KSARM         SETLL     SCSARML2                           8585                     S0140
     C*    KSARM         READE     SCSARML2                               85                   S0140
      *
     C*    *IN85         DOWEQ     '0'                                                         S0140
     C*                  DELETE    @SARML2                                                     S0140
     C*    KSARM         READE     SCSARML2                               85                   S0140
     C*                  END                                                                   S0140
      *
     C                   END                                                                   S0140
      * USER: Processing after DBF update
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SICHRC        BEGSR
      *================================================================
      * Change Report Components - Report Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before DBF read
     C                   MOVEL     #1SVAL        GJSVAL                         Report name
     C*                  MOVEL     #1HDER        GJVDTA                         Component Name
      *
     C     KLCHSI        KLIST
     C                   KFLD                    GJSVAL                         Report name
     C                   KFLD                    GJVDTA                         Component Name
      *
      *
      * Check for changed record.
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'RCF1085'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C                   GOTO      SIEXIT
     C                   END                                                    FI #1DBRC
      *
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
      * Update saved record image.
     C                   MOVEL     @1DBRC        #1DBRC
      * USER: Processing after DBF update
     C*
     C** EDIT REPORT COMPONENTS PROCESSING AFTER CHANGE
     C                   END
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   SJRVGN        BEGSR
      *================================================================
      * Set last change date/type - Report Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C/EXEC SQL
     C+ SELECT *
     C+ into :SDSVALL
     C+ from SDSVLJW0
     C+ where GISVAL = :P1SVAL
     C/END-EXEC
     C                   IF        SQLCODE = 100
     C                   SETON                                        90
     C                   ELSE
     C                   SETOFF                                       90
     C                   ENDIF
      * DBF Record not found.
     C   90              MOVEL     'USR4616'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
     C                   MOVEL     @CN(02)       WUJTST                         Action Code
      * Change Report Description - Report Descriptions  *
     C                   EXSR      SKCHRC
     C                   END
      *================================================================
     CSR   SJEXIT        ENDSR
      /EJECT
     CSR   SKCHRC        BEGSR
      *================================================================
      * Change Report Description - Report Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      *CASE:     PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   MOVEL     @CN(08)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      *CASE:     PGM.*Return code is *Previous Screen
     C     W0RTN         IFEQ      @CN(09)                                      *IF
     C                   GOTO      SKEXIT                                       *QUIT
     C                   END                                                    *FI
      *
     C*    KLCHSK        KLIST
     C*                  KFLD                    DXSVAL                         Report name
     C*                  MOVEL     DXSVAL        KKSVAL
     C/EXEC SQL
     C+ SELECT *
     C+ into :SDSVALL :NullIndsL
     C+ from SDSVLJW0
     C+ where GISVAL = :KKSVAL
     C/END-EXEC
     C                   IF        SQLCODE = 100
      *
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
     C                   MOVEL     'USR4616'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SKEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SKEXIT
     C                   END
      *
     C*                  Z-ADD     WURUND        DXLCD                          Last Change Dat
     C*                  MOVEL     @CN(02)       DXCHTP                         Type of Last Ch
     C                   MOVEL     @CN(02)       XXCHTP                         Type of Last
      *
     C                   IF        GIMODE = 'B'
     C/EXEC SQL
     C+ update SDSVLBTD
     C+  SET GILCT  = :XXCHTP
     C+ , GILCD = :WURUND
     C+ WHERE GISVAL = :KKSVAL
     C/END-EXEC

     C                   ENDIF

     CSR   SKEXIT        ENDSR
      *================================================================
      /EJECT
      *================================================================
     CSR   VACKRL        BEGSR
      * Name search required ?
     C                   MOVEL     #2SVAL        WK1X01            1            Report name
     C/EXEC SQL
     C+ SELECT *
     C+ into :SDSVAL :NullInds
     C+ from SDSVLJW1
     C+ where GISVAL = :#2SVAL
     C/END-EXEC
     C                   IF        SQLCODE = 100
     C                   SETON                                        90
     C                   ELSE
     C                   SETOFF                                       90
     C                   ENDIF
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals.
     C                   GOTO      VAEXIT
     C                   END
     C     VA999         TAG
      * Restrictor relation not satisfied
      * Send message 'System Value not found'
     C                   MOVEL     'USR4616'     ZAMSID                         Message id.
     C                   MOVEL     '*PRV '       ZAPGRL                         Pgmq rel.
     C                   EXSR      ZASNMS                                       Send message
     C                   MOVEL     'USR4616'     P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   VAEXIT        ENDSR
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
      * USER: Exit program processing
      *CASE:     CTL.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
      *CASE:     WRK.Update Made is Update Made
     C     WUAZST        IFEQ      @CN(07)                                      *IF
      * Set last change date/type - Report Descriptions  *
     C                   EXSR      SJRVGN
     C                   END                                                    *FI
     C                   MOVEL     @CN(08)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C*Edit Report Components   Exit Program Processing
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
     C/EXEC SQL
     C+ close ACursor
     C/END-EXEC

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
      * Define work field Action Code
     C                   MOVEL     *BLANK        WUJTST            1
      * Obtain default message file.
     C     *DTAARA       DEFINE    FCMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Update Made
     C                   MOVEL     *BLANK        WUAZST            1
      * Define work field run day number
     C                   Z-ADD     *ZERO         WURUND            5 0
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WURUNA            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSSF             1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUDATF            1
      *
     C                   Z-ADD     03            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
     C                   Z-ADD     *ZERO         ##RRMX                         MAX RECNO
      *................................................................
      * Set to *CHANGE mode.
     C                   MOVEL     'CHG'         W0PMD             3            Change mode
     C                   MOVEL     'Y'           W0APM             1            First time
      * USER: Initialise program
      * Initialise EDTFIL program
      * get rundate - rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      RUNA          ##RUNA
     C                   MOVE      RUNA          WURUNA
     C                   MOVE      RUND          WURUND
     C                   MOVE      SSF           WUSSF
     C                   MOVE      DATF          WUDATF
     C                   MOVE      MBIN          WUMBIN
      * Standard RPG Creation PAR - standard functions  *
      *  C R E A T I O N     P A R A M E T E R S
      *
      *
      ********************************************************************
      * Copyright Statement - standard functions  *
     C                   MOVEA     CPY@          BIS@             80
      * Set up EDTFIL screen - standard functions  *
     C                   MOVEA     AEMQ(1)       ##AENA
      * Initialise subfile control.
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
     O*Edit Report Components   Initialise Program O-Spec
*******F3=Main Menu   F9=Go To 'Add' Mode   F12=Previous                  LN1146
**
F3=Main Menu  F12=Previous
D=Delete   F3=Main Menu   F9=Go To 'Add' Mode   F12=Previous
** CPY@
(c) Finastra International Limited 2001
** @CN Long constants used in program.
CHG
A
B
ADD
I
Y2U0005
Y
Y2U9999
RCF0790
FCREPTPD
N
