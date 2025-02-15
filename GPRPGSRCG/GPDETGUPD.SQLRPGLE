     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD056556
/*STD *  RPGSQLBND                                                    *                     MD056556
/*EXI *  TEXT('Midas GP Determine Global Updates')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPDETGUPD - Determine Global Updates                         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD059340           Date 05Jan22               *
      *  Prev Amend No. MD057689           Date 04Mar21               *
      *                 MD056556           Date 13Aug20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059340 - Performance issue with repeating accesses to      *
      *             view GPGLFJW0 while ODP are not re-usable.        *
      *             Store data into array as cache.                   *
      *  MD057689 - Amending branch of batch header creates a new     *
      *             record in GZ file. Correct access to GPGLFJW0.    *
      *  MD056556 - Deliverable Data Split for GPGLOBFPD              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     FGPKEYDPD  IF   E           K DISK    INFSR(*PSSR)
     F*GPGLOBFPD IF   E           K DISK    INFSR(*PSSR)                                    MD056556


     D #_SPOS          S              4  0 DIM(10)
     D #_SIZE          S              4  0 DIM(10)
     D GPGLOBF       E DS                  EXTNAME(GPGLFJW0)                                MD056556
     D Idx             S              3  0                                                  MD059340
     D IX              S              3  0                                                  MD059340
     D GFileDS         DS                                                                   MD059340
     D GPGLF                               DIM(500)                                         MD059340
     D ZFile                         10A   OVERLAY(GPGLF : *NEXT)                           MD059340
     D GFile                         10A   OVERLAY(GPGLF : *NEXT)                           MD059340


     C     *ENTRY        PLIST
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#FILE           10
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C                   PARM                    O#Before          1
     C                   PARM                    O#After           1

      * Initialize outputs

     C                   MOVE      'N'           O#Before
     C                   MOVE      'N'           O#After

      * On change of file, get key fields

     C     I#FILE        IFNE      Prev_FILE
     C                   EXSR      GET_FIELDS
     C                   ENDIF

      * Determine 'before' and 'after' keys

     C                   MOVEL     *BLANK        Before_Key      100
     C                   MOVEL     *BLANK        After_Key       100
     C     KeyData       IFEQ      'Y'
     C     I#BIMG        IFNE      *BLANK
     C     I#AIMG        ANDNE     *BLANK
     C                   EXSR      DET_KEYS
     C                   ENDIF
     C                   ENDIF

      * Reverse 'Before'
      * ================

     C     I#BIMG        IFNE      *BLANK
     C     I#AIMG        ANDNE     *BLANK
     C     Before_Key    ANDNE     After_Key
     C     I#BIMG        ORNE      *BLANK
     C     I#AIMG        ANDEQ     *BLANK
     C                   MOVEL     'Y'           O#Before
     C                   ENDIF

      * Apply 'After'
      * =============

     C     I#AIMG        IFNE      *BLANK
     C                   MOVEL     'Y'           O#After
     C                   ENDIF

     C                   RETURN
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Determine 'before' and 'after' keys
      *********************************************************************
     C     DET_KEYS      BEGSR

      * Step through key fields
      * to create the before image key

     C                   Z-ADD     1             KEYPtr            4 0
     C                   Z-ADD     1             C                 4 0

     C     C             DOWLE     10
     C     #_SPOS(C)     ANDNE     *ZERO

     C                   Z-ADD     #_SPOS(C)     StartPos          4 0
     C                   Z-ADD     #_SIZE(C)     FieldSiz          4 0

     C     KEYPtr        ifle      100
     C                   EVAL      %subst(Before_Key:KEYPtr:FieldSiz) =
     C                               %subst(I#BIMG:StartPos:FieldSiz)
     C                   EVAL      KEYPtr = KEYPtr + FieldSiz
     C                   endif

     C                   ADD       1             C

     C                   ENDDO

      * Step through key fields
      * to create the after image key

     C                   Z-ADD     1             KEYPtr            4 0
     C                   Z-ADD     1             C                 4 0

     C     C             DOWLE     10
     C     #_SPOS(C)     ANDNE     *ZERO

     C                   Z-ADD     #_SPOS(C)     StartPos          4 0
     C                   Z-ADD     #_SIZE(C)     FieldSiz          4 0

     C     KEYPtr        ifle      100
     C                   EVAL      %subst(After_Key:KEYPtr:FieldSiz) =
     C                               %subst(I#AIMG:StartPos:FieldSiz)
     C                   EVAL      KEYPtr = KEYPtr + FieldSiz
     C                   endif

     C                   ADD       1             C

     C                   ENDDO

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * GET FIELDS
      *********************************************************************
     C     GET_FIELDS    BEGSR

     C                   MOVEL     I#FILE        Prev_FILE        10
     C                   MOVEL     'N'           KeyData           1

     C                   Z-ADD     1             C                 4 0
     C                   Z-ADD     *ZERO         #_SPOS
     C                   Z-ADD     *ZERO         #_SIZE
     C                   Z-ADD     1             IX                                         MD059340

     C     I#FILE        LOOKUP    ZFILE(IX)                              99                MD059340
     C     *IN99         IFEQ      '0'                                                      MD059340
      * Access the global physical file name

     C*****I#FILE        CHAIN     GPGLOBFD0                          99                    MD056556
     C/EXEC SQL                                                                             MD056556
     C+ SELECT *                                                                            MD056556
     C+ into :GPGLOBF                                                                       MD056556
     C+ from GPGLFJW0                                                                       MD056556
     C**where*GFGPF = :I#FILE                                                      MD056556 MD057689
     C+ where GFZPF = :I#FILE                                                               MD057689
     C/END-EXEC                                                                             MD056556
     C******IN99         IFEQ      *OFF                                                     MD056556
     C                   IF        SQLCODE = 0                                              MD059340
     C                   ADD       1             Idx                                        MD059340
     C                   EVAL      ZFILE(Idx) = I#FILE                                      MD059340
     C                   EVAL      GFILE(Idx) = GFGPF                                       MD059340
     C                   ENDIF                                                              MD059340
     C                   ELSE                                                               MD059340
     C                   EVAL      SQLCODE = 0                                              MD059340
     C                   EVAL      GFGPF = GFILE(IX)                                        MD059340
     C                   ENDIF                                                              MD059340
                                                                                            MD059340
     C                   IF        SQLCODE = 0                                              MD056556

      * Load up the key fields of the global physical file

     C     GPKEYDK       SETLL     GPKEYDD0
     C     GPKEYDK       READE     GPKEYDD0                               99
     C     *IN99         DOWEQ     *OFF
     C     C             ANDLE     10
     C                   MOVEL     'Y'           KeyData
     C                   MOVEL     FDSPOS        #_SPOS(C)
     C                   MOVEL     FDSIZE        #_SIZE(C)
     C                   ADD       1             C
     C     GPKEYDK       READE     GPKEYDD0                               99
     C                   ENDDO
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR

     C                   MOVE      *BLANK        I#RTCD            7
     C                   MOVE      *BLANK        I#ERMS           50

      * Key lists

     C     GPKEYDK       KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    GFGPF
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
