     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Base rate codes browse')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDBSRTBRW - Base Rates Details Browse                        *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One displays a list of Base Rate details          *
      *             for selection , the other picks off the           *
      *             selection made.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR814519           Date 11Mar15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 203798             Date 11Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP038  *CREATE    Date 06Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR814519 - Allow negative base rate.                         *
      *           - Applied for MD033488                              *
      *  203798 - Enhanced browsing                                   *
      *  CAP038 - Midas Data Feed                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDBSRTBRDFCF   E             WORKSTN
     F                                     SFILE(SDBSRTS1:@@RRN)
     F                                     SFILE(SDBSRTS3:@@RRN)
      * FUNCTION Transaction Details File - by Transaction number
     FSDBSRTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BAREDG:FILETRNN)
     FSDBSRTL2  IF   E           K DISK    INFSR(*PSSR)                                       203798
     F                                     RENAME(SDBSRTD0:SDBSRTF2)                          203798
      ** Transaction file - by Front Office Id.
     FSDBSRFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BAREDI:FILEFOID)

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)

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
      *
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


      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D INPSSN          S                   LIKE(DDCYCD )
     D INPCNM          S                   LIKE(DDBSRC )
                                                                                              203798
      * Current Selection Fields                                                              203798
     D                 DS                                                                     203798
     D Curr_SEL                1     53                                                       203798
     D CurrCYCD                1      3                                                       203798
     D CurrBSRC                4      5                                                       203798
     D CurrBSRN                6     35                                                       203798
     D CurrBASER              36     47                                                       203798
     D CurrDATE               48     53                                                       203798
     D                 DS                                                                     203798
     D Curr_SEL2               1     25                                                       203798
     D CurrFODN                1     20                                                       203798
     D CurrCYCD2              21     23                                                       203798
     D CurrBSRC2              24     25                                                       203798
                                                                                              203798
      * Previous Selection Fields                                                             203798
     D                 DS                                                                     203798
     D Prev_SEL                1     53                                                       203798
     D                 DS                                                                     203798
     D Prev_SEL2               1     25                                                       203798
                                                                                              203798
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
      ** Set up the transaction reference to be used by the message handler
     C                   EVAL      TranRef = DDCYCD
     C                   EVAL      ActionCode = DDACTN

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------

      ** Initialization
      *
     C                   EXSR      INIT

      ** BUILD Sub-file

     C     @BDSFL        IFEQ      'Y'
      *
      **  If First time in or subfile by Midas transaction number was previously
      **  being run, then build subfile keyed on Midas transaction number.
      **  Stay in loop while F11 toggle key is used.
      *
     C     WTrnK         IFNE      'F'
     C     WTrnK         ANDNE     'S'
     C                   MOVE      'B'           WTrnK
      *
     C                   ENDIF
      *
     C     *INKK         DOUEQ     '0'
      *
      ** On F11, initialize position/select fields
      *
     C     *INKK         IFEQ      '1'
      *
     C                   MOVE      *BLANK        DDCYCD
     C                   MOVE      *BLANK        DDBSRC
     C                   Z-ADD     *ZERO         #BaseR
     C                   MOVE      *BLANK        #BASES                                     AR814519
     C                   MOVE      *BLANK        #Date
     C                   MOVE      *BLANK        DDFODN

      ** Clear program message queue
     C                   CALL      'ZA0250'

     C                   ENDIF

     C     WTrnK         CASEQ     'B'           BLDSFL
     C     WTrnK         CASEQ     'F'           BLDSFL2
     C                   ENDCS
     C                   ENDDO

     C                   ENDIF

      ** READ Subfile Record

     C     @RDSFL        IFEQ      'Y'
     C     WTrnK         ANDNE     *BLANK
     C                   EXSR      RDSFLR
     C                   END


     C                   RETURN

      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *                                                                                       203798
      ** Do until selection is not changed or F/11 is taken                                   203798
      *                                                                                       203798
     C     Curr_SEL      DOUEQ     Prev_SEL                                                   203798
     C     *INKK         OREQ      '1'                                                        203798
                                                                                              203798
      ** Update record selection fields                                                       203798
                                                                                              203798
     C                   EXSR      UPD_SELECT                                                 203798
                                                                                              203798
     C                   MOVEL     Curr_SEL      Prev_SEL                                     203798
      *
      ** Validate Transaction Reference (FOR POINTER)
      *
     C                   EXSR      VALTran
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDBSRTS0
     C                   MOVE      '0'           *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C     INCYCD        IFEQ      *BLANK                                                     203798
     C     INBSRC        ANDNE     *BLANK                                                     203798
     C     KEY2          SETLL     SDBSRTL2                                                   203798
     C                   ELSE                                                                 203798
     C     KEY1          SETLL     SDBSRTL0
     C                   ENDIF                                                                203798
      *
      **  Read a Valid Transaction
      *
     C                   EXSR      RDTran
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      **  or the selection is changed.                                                        203798
      *
     C     *IN98         DOWEQ     '1'
     C     Curr_SEL      ANDEQ     Prev_SEL                                                   203798
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Format transaction fields for output
      *
     C                   EXSR      FMTtran
      *
      **  Write the transaction to the subfile.
      *
      **  If action code or Transaction number selected is invalid
      **  the subfile postions on the error record and rebuilds
      *
     C                   MOVE      *OFF          *IN92
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDCYCD    '  LOOKUP    FldNameArr                             99
     C     'DDBSRC    '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SDBSRTS1
      *
      **  Read a valid Transaction
      *
     C                   EXSR      RDTran
     C                   ENDDO
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     SDBSRTF1
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDBSRTS0
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     c                   MOVE      '1'           *IN93
     C                   WRITE     SDBSRTS1
     c                   MOVE      '0'           *IN93
     C                   WRITE     SDBSRTS0
     c                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDBSRTS0
     c                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDBSRTS0                               99
                                                                                              203798
      ** Update record selection fields                                                       203798
                                                                                              203798
     C                   EXSR      UPD_SELECT                                                 203798
      *
      ** Clear any messages before processing user input
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      **  If F3, bypass further processing.
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F9, bypass further processing.
     C     *INKI         IFEQ      '1'
     C                   MOVEL     'I'           @OPSEL
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   END
                                                                                              203798
     C                   ENDDO                                                                203798
      *
      * Set indicator ans flag for Midas Front Office I.D. browse key   used
      *
     C     *INKK         IFEQ      '1'
     C                   MOVE      'F'           WTrnK             1
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL2 - BUILD SUBFILE by FRONT OFFICE ID.
      ********************************************************************

     C     BLDSFL2       BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * Validate Transaction N(FOR POINTER)
      *
     C                   EXSR      VALTran
      *
      **  Get Front Office Transaction Reference
      *
     C     INCYCD        IFEQ      *BLANK                                                     203798
     C     INBSRC        ANDNE     *BLANK                                                     203798
     C     KEY2          SETLL     SDBSRTL2                                                   203798
     C                   READ      SDBSRTL2                               89                  203798
     C                   ELSE                                                                 203798
     C*****KEY1**********CHAIN     SDBSRTL0                           89                      203798
     C     KEY1          SETLL     SDBSRTL0                                                   203798
     C                   READ      SDBSRTL0                               89                  203798
     C                   ENDIF                                                                203798
     C*******************MOVE******BAFRNT********@@FOID           20                          203798
     C******IN89*********IFEQ******'1'***********                                             203798
     C*******************MOVE*******BLANK********@@FOID                                       203798
     C*******************END*********************                                             203798
     C     *IN89         IFEQ      '0'                                                        203798
     C                   MOVE      BAFRNT        DFODN                                        203798
     C                   MOVE      BACYCD        DCYCD                                        203798
     C                   MOVE      BABSRC        DBSRC                                        203798
     C                   ELSE                                                                 203798
     C                   MOVE      *BLANK        DFODN                                        203798
     C                   MOVE      *BLANK        DCYCD                                        203798
     C                   MOVE      *BLANK        DBSRC                                        203798
     C                   END                                                                  203798
      *                                                                                       203798
      ** Do until selection is not changed or F/11 is taken                                   203798
      *                                                                                       203798
     C     Curr_SEL2     DOUEQ     Prev_SEL2                                                  203798
     C     *INKK         OREQ      '1'                                                        203798
                                                                                              203798
     C                   MOVEL     DFODN         @@FOID           20                          203798
     C                   MOVEL     DCYCD         @@CYCD            3                          203798
     C                   MOVEL     DBSRC         @@BSRC            2                          203798
     C                   MOVEL     DFODN         CurrFODN                                     203798
     C                   MOVEL     DCYCD         CurrCYCD2                                    203798
     C                   MOVEL     DBSRC         CurrBSRC2                                    203798
     C                   MOVEL     Curr_SEL2     Prev_SEL2                                    203798
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDBSRTS2
     C                   MOVE      '0'           *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C*****@@FOID********SETLL     SDBSRFL0                                                   203798
     C     @@FOIDK       SETLL     SDBSRFL0                                                   203798
      *
      ** Read a Valid Trade
      *
     C                   EXSR      RDTran
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      **  or the selection is changed.                                                        203798
      *
     C     *IN98         DOWEQ     '1'
     C     Curr_SEL2     ANDEQ     Prev_SEL2                                                  203798
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format custo fields for output
      *
     C                   EXSR      FMTtran
      *
      **  Write the customer to the subfile.
      *
      **  If action code or Transaction number selected is invalid,
      **  the subfile postions on the error record and rebuilds
      *
     C                   MOVE      *OFF          *IN92
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDCYCD    '  LOOKUP    FldNameArr                             99
     C     'DDBSRC    '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SDBSRTS3
      *
      ** Read a valid Transaction
      *
     C                   EXSR      RDTran
     C                   END
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     SDBSRTF1
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     c                   MOVE      '1'           *IN97
     C                   WRITE     SDBSRTS2
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     C                   MOVE      '1'           *IN93
     C                   WRITE     SDBSRTS3
     C                   MOVE      '0'           *IN93
     C                   WRITE     SDBSRTS2
     C                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDBSRTS2
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDBSRTS2                               99
                                                                                              203798
     C                   MOVEL     DFODN         CurrFODN                                     203798
     C                   MOVEL     DCYCD         CurrCYCD2                                    203798
     C                   MOVEL     DBSRC         CurrBSRC2                                    203798
      *
      ** Clear any messages before processing user input
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F9, bypass further processing.
      *
     C     *INKI         IFEQ      '1'
     C                   MOVEL     'I'           @OPSEL
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   END
                                                                                              203798
     C                   ENDDO                                                                203798
      *
      * Set indicator and flag for Midas (back) office Transaction number key
      *
     C     *INKK         IFEQ      '1'
     C                   MOVE      'B'           WTrnK
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK

     C     WTrnK         IFEQ      'B'
     C                   READC     SDBSRTS1                               99
     C                   ENDIF
     C     WTrnK         IFEQ      'F'
     C                   READC     SDBSRTS3                               99
     C                   ENDIF

     C                   END
      *
      **  Return the selected transaction reference and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   END
      *
     C                   MOVE      DDBSRC        @BSRC
     C                   MOVE      DDCYCD        @CYCD
      *
     C                   END
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTtran - FORMAT TRANSACTION FOR OUTPUT
      ******************************************************************
     C     FMTTRan       BEGSR
     C                   MOVE      BACYCD        DDCYCD
     C                   MOVE      BABSRC        DDBSRC
     C                   MOVE      BABSRN        DDBSRN
     C                   Z-ADD     BACBSR        #BaseR
      *                                                                                     AR814519
     C                   IF        BACBSR < 0                                               AR814519
     C                   MOVE      '-'           #BASES                                     AR814519
     C                   ELSE                                                               AR814519
     C                   MOVE      '+'           #BASES                                     AR814519
     C                   ENDIF                                                              AR814519
      *                                                                                     AR814519
     C                   IF        BAVDNR  <> 0
     C                   Z-ADD     BANBRT        #BaseR
      *                                                                                     AR814519
     C                   IF        BANBRT < 0                                               AR814519
     C                   MOVE      '-'           #BASES                                     AR814519
     C                   ELSE                                                               AR814519
     C                   MOVE      '+'           #BASES                                     AR814519
     C                   ENDIF                                                              AR814519
      *                                                                                     AR814519
     C                   ENDIF
     C                   Z-ADD     BAVDRC        WUWMDT
     C                   IF        BAVDNR <> 0
     C                   Z-ADD     BAVDNR        WUWMDT
     C                   ENDIF
      * Check File Date
     C                   CALLB     'ZDATE2'
     C                   PARM                    WUWMDT            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         WUWCDT            6 0
     C                   PARM      *BLANK        WUWADT            7
      *
      *
     C                   MOVEL     WUWADT        #Date
     C                   MOVE      BAFRNT        DDFODN
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * RDTran - READ A TRANSACTION
      *****************************************************************
     C     RDTran        BEGSR
      *
      **  Reset End of File and skip record indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     @@ERR         OREQ      *ZERO
      *
      **  Read the file
      *
      **  Position according to Transaction number
      *
     C     WTrnK         IFEQ      'B'
     C     INCYCD        IFEQ      *BLANK                                                     203798
     C     INBSRC        ANDNE     *BLANK                                                     203798
     C                   READ      SDBSRTF2                               96                  203798
     C                   ELSE                                                                 203798
     C                   READ      FILETRNN                               96
     C                   ENDIF                                                                203798
     C                   EXSR      CHK_SELECT                                                 203798
     C                   ENDIF
      *
      **  Position according to Front Office Id
      *
     C     WTrnK         IFEQ      'F'
     C                   READ      FILEFOID                               96
     C                   ENDIF
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
     C                   ENDDO
      *
     C     ERDCUST       ENDSR
      *****************************************************************
      /EJECT                                                                                  203798
      *****************************************************************                       203798
      * UPD_SELECT - UPDATE RECORD SELECTION FIELDS                                           203798
      *****************************************************************                       203798
     C     UPD_SELECT    BEGSR                                                                203798
                                                                                              203798
     C                   MOVEL     INCYCD        CurrCYCD                                     203798
     C                   MOVEL     INBSRC        CurrBSRC                                     203798
     C                   MOVEL     INBSRN        CurrBSRN                                     203798
     C                   MOVEL     INBASER       CurrBASER                                    203798
     C                   MOVEL     INDATE        CurrDATE                                     203798
                                                                                              203798
      * Convert input base rate                                                               203798
                                                                                              203798
     C                   MOVE      *BLANKS       ZFIELD                                       203798
     C                   MOVE      INBASER       ZFIELD                                       203798
     C                   CALLB     'ZALIGN'                                                   203798
     C                   PARM                    ZALIGNOK          1                          203798
     C                   PARM                    ZFIELD           16                          203798
     C                   PARM      7             ZADEC             1 0                        203798
     C                   PARM      4             ZADIG             2 0                        203798
     C     ZALIGNOK      IFEQ      'Y'                                                        203798
     C                   MOVE      ZFIELD        SelBASER         11 7                        203798
     C                   ELSE                                                                 203798
     C                   Z-ADD     *ZERO         SelBASER                                     203798
     C                   ENDIF                                                                203798
                                                                                              203798
      * Convert input (value) date                                                            203798
                                                                                              203798
     C                   MOVE      *BLANKS       ZFIELD                                       203798
     C                   MOVE      INDATE        ZFIELD                                       203798
     C                   CALLB     'ZALIGN'                                                   203798
     C                   PARM                    ZALIGNOK          1                          203798
     C                   PARM                    ZFIELD           16                          203798
     C                   PARM      0             ZADEC             1 0                        203798
     C                   PARM      6             ZADIG             2 0                        203798
     C     ZALIGNOK      IFEQ      'Y'                                                        203798
     C                   MOVE      ZFIELD        ZDATE                                        203798
     C                   CALLB     'ZDATE1'                                                   203798
     C                   PARM                    ZDATE             6                          203798
     C                   PARM      *ZERO         SelDate           5 0                        203798
     C                   PARM                    BJDFIN                                       203798
     C                   PARM                    Errorflag         1                          203798
     C                   ELSE                                                                 203798
     C                   Z-ADD     *ZERO         SelDATE                                      203798
     C                   ENDIF                                                                203798
                                                                                              203798
     C                   ENDSR                                                                203798
      *****************************************************************                       203798
      /EJECT                                                                                  203798
      *****************************************************************                       203798
      * CHK_SELECT - CHECK FOR RECORD SELECTION                                               203798
      *****************************************************************                       203798
     C     CHK_SELECT    BEGSR                                                                203798
                                                                                              203798
     C                   Z-ADD     *ZERO         @@ERR                                        203798
                                                                                              203798
      * Scan for search string                                                                203798
     C     INBSRN        IFNE      *BLANK                                                     203798
     C                   CALL      'QCLSCAN'                                                  203798
     C                   PARM                    BABSRN                                       203798
      * Length                                                                                203798
     C                   PARM      30            WQA3N             3 0                        203798
      * Start                                                                                 203798
     C                   PARM      1             WQB3N             3 0                        203798
      * Mask                                                                                  203798
     C                   PARM                    INBSRN                                       203798
      * Length                                                                                203798
     C                   PARM      30            WQC3N             3 0                        203798
      * Translate                                                                             203798
     C                   PARM      '1'           WQD1              1                          203798
      * Trim                                                                                  203798
     C                   PARM      '1'           WQE1              1                          203798
      * Wild                                                                                  203798
     C                   PARM      '?'           WQF1              1                          203798
      * Result                                                                                203798
     C                   PARM                    WQG3N             3 0                        203798
                                                                                              203798
     C     WQG3N         IFLT      1                                                          203798
     C                   Z-ADD     9             @@ERR                                        203798
     C                   ENDIF                                                                203798
     C                   ENDIF                                                                203798
                                                                                              203798
      * Select on base rate                                                                   203798
                                                                                              203798
     C     SelBASER      IFNE      *ZERO                                                      203798
     C                   Z-ADD     BACBSR        #BaseR                                       203798
      *                                                                                     AR814519
     C                   IF        BACBSR < 0                                               AR814519
     C                   MOVE      '-'           #BASES                                     AR814519
     C                   ELSE                                                               AR814519
     C                   MOVE      '+'           #BASES                                     AR814519
     C                   ENDIF                                                              AR814519
      *                                                                                     AR814519
     C                   IF        BAVDNR  <> 0                                               203798
     C                   Z-ADD     BANBRT        #BaseR                                       203798
      *                                                                                     AR814519
     C                   IF        BANBRT < 0                                               AR814519
     C                   MOVE      '-'           #BASES                                     AR814519
     C                   ELSE                                                               AR814519
     C                   MOVE      '+'           #BASES                                     AR814519
     C                   ENDIF                                                              AR814519
      *                                                                                     AR814519
     C                   ENDIF                                                                203798
     C     SelBASER      IFNE      #BaseR                                                     203798
     C                   Z-ADD     9             @@ERR                                        203798
     C                   ENDIF                                                                203798
     C                   ENDIF                                                                203798
                                                                                              203798
      * Select on (value) date                                                                203798
                                                                                              203798
     C     SelDATE       IFNE      *ZERO                                                      203798
     C                   Z-ADD     BAVDRC        WUWMDT                                       203798
     C                   IF        BAVDNR <> 0                                                203798
     C                   Z-ADD     BAVDNR        WUWMDT                                       203798
     C                   ENDIF                                                                203798
     C     SelDATE       IFNE      WUWMDT                                                     203798
     C                   Z-ADD     9             @@ERR                                        203798
     C                   ENDIF                                                                203798
     C                   ENDIF                                                                203798
                                                                                              203798
     C                   ENDSR                                                                203798
      *****************************************************************                       203798
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTran - VALIDATE TRANSACTION REFERENCE POINTER
      *****************************************************************
     C     VALTran       BEGSR
     C                   MOVEL     INCYCD        DDCYCD
     C                   MOVEL     INBSRC        DDBSRC
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @BSRC
     C                   MOVE      *BLANK        @CYCD
     C                   MOVE      '0'           @INKC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return Code
     C                   PARM                    RetCodeIn
      * Action Code
     C                   PARM                    DDACTN            1
      * Transaction Reference Pointers
     C                   PARM                    INCYCD            3
     C                   PARM                    INBSRC            2
      * Build Subfile
     C                   PARM                    @BDSFL            1
      * Read Subfile Record
     C                   PARM                    @RDSFL            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * OUTPUT PARAMETERS :
      * Error Message
      * Option Selected
      * Transaction Reference selected
     C                   PARM                    @ERRMS            7
     C                   PARM                    @OPSEL            1
     C                   PARM                    @CYCD             3
     C                   PARM                    @BSRC             2
      * Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1

     C     KEY1          KLIST
     C                   KFLD                    DDCYCD
     C                   KFLD                    DDBSRC
     C     KEY2          KLIST                                                                203798
     C                   KFLD                    DDBSRC                                       203798
     C     @@FOIDK       KLIST                                                                203798
     C                   KFLD                    @@FOID                                       203798
     C                   KFLD                    @@CYCD                                       203798
     C                   KFLD                    @@BSRC                                       203798
      *
      ** Initialize program name
     C                   MOVEL     'SDBSRTBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
      *
     C                   MOVE      '1'           *IN94
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
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
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------

     C                   ENDSR
      *****************************************************************
      *
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------

      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
