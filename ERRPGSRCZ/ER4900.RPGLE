     H DEBUG
     H COPYRIGHT('(C) Copyright Midas-Kapiti International Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*OVR *  OVRDBF FILE(ER4900PDT3) TOFILE(QADSPFFD) SHARE(*NO)          *
/*OVR *  OVRDBF FILE(ER4900PDT4) TOFILE(QADSPFFD) SHARE(*NO)          *
/*EXI *  TEXT('Midas ER Record matching engine')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Compare utility                                      *
      *                                                               *
      *  ER4900 - Record matching engine                              *
      *                                                               *
      *  Function:  This is the main program responsible for matching *
      *             records from two files                            *
      *                                                               *
      *  (C) Copyright Midas-Kapiti International Ltd. 2001           *
      *                                                               *
      *  Last Amend No. MD058100           Date 20May21               *
      *  Prev Amend No. MMI100  *CREATE    Date 22Aug01               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058100 - Rollup of additional BoI onsite fixes at FbMidas  *
      *  LUC139 - Upgrade UCI Italian Returns                         *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      * The program has some hardcode limitations:                    *
      * - Internally defined record is set to 10000 chars             *
      *   (check all instances)                                       *
      * - Number of fields is set to 1500                             *
      * - Temporary fields have hardcoded length in *INZSR            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

      * DSPFFD output files (used twice)
     FER4900PDT3IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(QWHDRFFD:ER4900T3)
     FER4900PDT4IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(QWHDRFFD:ER4900T4)

      * Files to compare
     FER4900PDT1IF   F10000        DISK    INFSR(*PSSR)
     FER4900PDT2IF   F10000        DISK    INFSR(*PSSR)

      * File for output
     FER4900PD  O    E             DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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

     D XArrayMax       C                   CONST(1500)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Arrays for file layout ($1 = File1 and $2 = File2 )
      * Explanations on the fields are on the DSPFFD output record layout

     D $1FLDE          S             10A   DIM(XArrayMax)
     D $2FLDE          S             10A   DIM(XArrayMax)

     D $1FOBO          S              5S 0 DIM(XArrayMax)
     D $2FOBO          S              5S 0 DIM(XArrayMax)

     D $1FLDB          S              5S 0 DIM(XArrayMax)
     D $2FLDB          S              5S 0 DIM(XArrayMax)

     D $1FLDD          S              2S 0 DIM(XArrayMax)
     D $2FLDD          S              2S 0 DIM(XArrayMax)

     D $1FLBH          S              1S 0 DIM(XArrayMax)

      * Arrays for int. descr. files

     D CMP1AR          S              1A   DIM(10000)
     D CMP2AR          S              1A   DIM(10000)

      * Data structures for the program described files

     D CMP1DS          DS         10000
     D CMP2DS          DS         10000

      * Temporary fields

     D $1WK01          S              1A   DIM(100)
     D $2WK01          S              1A   DIM(100)

      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--------------------------------------+
      ** ¦ Main processing                      ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Start only if  work files contain data
     C     $1IDX         IFNE      0

      * Compare arrays to ID matching fields
     C                   EXSR      CMPARRAY

      * Process program described files
     C                   EXSR      CMPFILES

     C                   ENDIF

     C                   SETON                                        LR
     C
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR

      * Parameters first

     C     *ENTRY        PLIST
     C                   PARM                    W0KEY            10

      * Initialise main indexes

     C                   Z-ADD     0             $1IDX             5 0
     C                   Z-ADD     0             $2IDX             5 0
      *
      * DSPFFD files: File1
      *
     C                   READ      ER4900PDT3                           99

      * The file is empty, cannot continue
     C     *IN99         IFEQ      true
     C                   EXSR      *PSSR
     C                   ENDIF

      * Loop into the DSPFFD output file
     C     *IN99         DOWEQ     false

     C                   EVAL      $1IDX = $1IDX + 1

 C   C                   MOVEL     WHFLDE        $1FLDE($1IDX)
 C   C                   Z-ADD     WHFOBO        $1FOBO($1IDX)
      * Performance issue in retriving the data later on, so I add 1 as an offset directly here
 C   C                   EVAL      $1FLDB($1IDX) = WHFLDB +1
      * Endo fo performance improvement

     C                   READ      ER4900PDT3                           9999

     C                   ENDDO
      *
      * DSPFFD files: File2
      *
     C                   READ      ER4900PDT4                           99

      * The file is empty, cannot continue
     C     *IN99         IFEQ      true
     C                   EXSR      *PSSR
     C                   ENDIF

      * Loop into the DSPFFD output file
     C     *IN99         DOWEQ     false

     C                   EVAL      $2IDX = $2IDX + 1

 C   C                   MOVEL     WHFLDE        $2FLDE($2IDX)
 C   C                   Z-ADD     WHFOBO        $2FOBO($2IDX)
      * Performance issue in retriving the data later on, so I add 1 as an offset directly here
 C   C                   EVAL      $2FLDB($2IDX) = WHFLDB +1
      * Endo fo performance improvement

     C                   READ      ER4900PDT4                           9999

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *CMPARRAY - Compare arrays of fields to ID common fields
      *****************************************************************
     C     CMPARRAY      BEGSR

      * Set up work fields
     C                   Z-ADD     1             $1CNT             5 0

      * Required to avoid modifying the index values for primary file
     C                   Z-ADD     $1IDX         $1WIDX            5 0

      * Loop through the arrays
     C     1             DO        $1WIDX        $1CNT

     C                   Z-ADD     1             $2CNT             5 0

     C     $1FLDE($1CNT) LOOKUP    $2FLDE($2CNT)                          98

      * Set the BOTH flag
     C     *IN98         IFEQ      true
     C                   MOVE      1             $1FLBH($1CNT)
     C                   ELSE
     C                   MOVE      0             $1FLBH($1CNT)
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *CMPFILES - Compare files int. described
      *****************************************************************
     C     CMPFILES      BEGSR

      * FIRST STEP: Identify the keys

      * Set up work fields
     C                   Z-ADD     1             $1CNT
     C                   Z-ADD     1             $2CNT

      * File indicator for when Master is less than Target (key-wise)
     C                   MOVE      '0'           *IN91

      * Build key references
     C     W0KEY         LOOKUP    $1FLDE($1CNT)                          97
     C     W0KEY         LOOKUP    $2FLDE($2CNT)                          96

      * On error, abort
     C     *IN97         IFEQ      false
     C     *IN96         OREQ      false
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Z-ADD     $1FOBO($1CNT) $1KP              5 0
     C                   Z-ADD     $1FLDB($1CNT) $1KL              5 0
     C                   Z-ADD     $2FOBO($2CNT) $2KP              5 0
     C                   Z-ADD     $2FLDB($2CNT) $2KL              5 0

      * SECOND STEP: Loop through the keys to find matches

      * Main search loop for a given key
     C                   READ      ER4900PDT1    CMP1DS                   99

     C     *IN99         DOWEQ     false

      * Populate the first key field
     C                   MOVEA     CMP1DS        CMP1AR
     C                   MOVEA     CMP1AR($1KP)  $1WK01
     C                   MOVEA     *BLANKS       $1WK01($1KL)
     C                   MOVEA     $1WK01        $1TMP2          100

      * Secondary loop for a given key

      * Read only if not read already, see indicator IN91 for info
     C     *IN91         IFEQ      '0'
     C                   READ      ER4900PDT2    CMP2DS                   98
     C                   ELSE
     C                   MOVE      '0'           *IN91
     C                   ENDIF

     C     *IN98         DOWEQ     false

      * Populate the second key field
     C                   MOVEA     CMP2DS        CMP2AR
     C                   MOVEA     CMP2AR($2KP)  $2WK01
     C                   MOVEA     *BLANKS       $2WK01($2KL)
     C                   MOVEA     $2WK01        $2TMP2          100

      * Act on different scenarios, but not all:
     C                   SELECT

      * Ok, they match: compare fields now
     C     $1TMP2        WHENEQ    $2TMP2
     C                   EXSR      CMPFIELDS
     C                   LEAVE

      * The primary key is less than target key: fetch new primary key
     C     $1TMP2        WHENLT    $2TMP2
     C                   MOVE      '1'           *IN91
     C                   LEAVE

     C                   ENDSL

     C                   READ      ER4900PDT2    CMP2DS                   98

     C                   ENDDO

     C                   READ      ER4900PDT1    CMP1DS                   99

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      * *CMPFIELDS- Compare fields within a record
      *****************************************************************
     C     CMPFIELDS     BEGSR

      * Loop through the record (primary file rules)
     C     1             DO        $1IDX         $3CNT             5 0

      * Is the field in both records? If not, skip it
     C     $1FLBH($3CNT) IFEQ      0
     C                   ITER
     C                   ENDIF

      * Set up fields
     C                   Z-ADD     $1FOBO($3CNT) $3KP              5 0
     C                   Z-ADD     $1FLDB($3CNT) $3KL              5 0

     C                   Z-ADD     1             $4CNT             5 0

      * Field exists, so this is only to retrieve the position
     C     $1FLDE($3CNT) LOOKUP    $2FLDE($4CNT)                          95

     C                   Z-ADD     $2FOBO($4CNT) $4KP              5 0
     C                   Z-ADD     $2FLDB($4CNT) $4KL              5 0

      * Populate the first field
     C                   MOVEA     CMP1AR($3KP)  $1WK01
     C                   MOVEA     *BLANKS       $1WK01($3KL)
     C                   MOVEA     $1WK01        $1TMP9          100

      * Populate the second field
     C                   MOVEA     CMP2AR($4KP)  $2WK01
     C                   MOVEA     *BLANKS       $2WK01($4KL)
     C                   MOVEA     $2WK01        $2TMP9          100

     C     $1TMP9        IFNE      $2TMP9
     C                   MOVEL     $1TMP2        IRKEY
     C                   MOVEL     $1FLDE($3CNT) IRFIELD
     C                   MOVEL     $1TMP9        IRMASTER
     C                   MOVEL     $2TMP9        IRTARGET
     C                   WRITE     ER4900D0
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(C) Copyright Midas-Kapiti International Ltd. 2001
