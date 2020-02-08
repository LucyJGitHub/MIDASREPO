     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*YES)                                                *
/*EXI *  TEXT('Midas LE Update Aggregate Facility History files')     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000062 - Midas LE Update Aggregate Facility History files  *
      *             based on the new structure
      *                                                               *
      *  Function:  This program will build the Aggregate Structure   *
      *             driving file and Update the Aggregate Facility    *
      *             History Files based on the driving file           *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE147  *CREATE    Date 28Sep11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CLE147 - Aggregate Facility                                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLETRGPPD  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETRAGD0:LETRGPD0)
     F                                     PREFIX(PRV_)
      ** Tranche-Aggregate Facilities Relationship
     FLETRAGL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Tran-Agg. Fclty Rel by BrCA & Agg. Fclty
     FLEAGDVPD  UF A E           K DISK    INFSR(*PSSR)
      ** Midas LE Aggregate Structure Driving File
     FLEAGHSL1  UF A E           K DISK    INFSR(*PSSR)
      ** Midas LE Agg.Fclty History Temporary File
     FLEAGHSX   O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(LEAGHSD0:LEAGHSX0)
      ** Midas LE Agg.Fclty History by Tranche
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      **------------------------------------------------------------------+
      ** The following /COPY line includes all the defined fields in the  ¦
      ** Program Status Data Structures.  They have meaningful            ¦
      ** names, prefixed by 'PS'.                                         ¦
     D/COPY ZACPYSRC,PSDS                                                 ¦
      **------------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D                 DS
     D ADPTFT
     D ADPTFN
     D DSFCTR                  1      5S 0
 
     D                 DS
     D ADPAFT
     D ADPAFN
     D DSFCAG                  1      5S 0
 
     D                 DS
     D ADCAFT
     D ADCAFN
     D DSACAG                  1      5S 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ACT@            S             80A
     D WRun            S              1A
     D WFND01          S              1A
     D WACTN           S              1A
 
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
 
      ** Build driving file
     C                   EXSR      BUILDDF
 
      ** Read driving file
     C                   EXSR      READDF
 
      ** Terminate Program
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * BLDDF  - Build Aggregate Structure driving file               *
      *                                                               *
      *****************************************************************
     C     BUILDDF       BEGSR
 
      ** Read all records from the PREVIOUS LETRAGPD
     C     *LOVAL        SETLL     LETRGPPD
     C                   READ      LETRGPPD
 
     C                   DOW       NOT %EOF(LETRGPPD)
 
     C     KLEDVL1       CHAIN     LEAGDVPD
     C                   IF        NOT %FOUND(LEAGDVPD)
      ** Previous Tranche
     C                   EVAL      ADPTBR = PRV_AGTRBR
     C                   EVAL      ADPTNM = PRV_AGTRNM
     C                   EVAL      ADPTFT = PRV_AGTRFT
     C                   EVAL      ADPTFN = PRV_AGTRFN
      * Previous Aggregate
     C                   EVAL      ADPABR = PRV_AGAGBR
     C                   EVAL      ADPANM = PRV_AGAGNM
     C                   EVAL      ADPAFT = PRV_AGAGFT
     C                   EVAL      ADPAFN = PRV_AGAGFN
      ** Current Tranche
     C                   EVAL      ADCTBR = *BLANKS
     C                   EVAL      ADCTNM = *BLANKS
     C                   EVAL      ADCTFT = 0
     C                   EVAL      ADCTFN = 0
      ** Current Aggregate
     C                   EVAL      ADCABR = *BLANKS
     C                   EVAL      ADCANM = *BLANKS
     C                   EVAL      ADCAFT = 0
     C                   EVAL      ADCAFN = 0
 
     C                   EVAL      WACTN = *BLANKS
     C
     C                   WRITE     LEAGDVD0
 
     C                   ENDIF
 
     C                   READ      LETRGPPD
 
     C                   ENDDO
 
      ** Read all records from the CURRENT LETRAGPD
     C     *LOVAL        SETLL     LETRAGL4
     C                   READ      LETRAGL4
 
     C                   DOW       NOT %EOF(LETRAGL4)
 
     C     KLEDVL2       CHAIN     LEAGDVPD
     C                   IF        NOT %FOUND(LEAGDVPD)
     C     KLEDVL3       CHAIN     LEAGDVPD
     C                   IF        %FOUND(LEAGDVPD)
     C                   EVAL      WFND01 = 'N'
     C                   DOW       NOT %EOF(LEAGDVPD)
     C                   IF        (ADCTBR =  *BLANKS
     C                             AND ADCTNM = *BLANKS
     C                             AND ADCTFT = 0
     C                             AND ADCTFN = 0)
     C                             AND
     C                             (ADCABR =  *BLANKS
     C                             AND ADCANM = *BLANKS
     C                             AND ADCAFT = 0
     C                             AND ADCAFN = 0)
      ** Current Tranche
     C                   EVAL      ADCTBR = AGTRBR
     C                   EVAL      ADCTNM = AGTRNM
     C                   EVAL      ADCTFT = AGTRFT
     C                   EVAL      ADCTFN = AGTRFN
      ** Current Aggregate
     C                   EVAL      ADCABR = AGAGBR
     C                   EVAL      ADCANM = AGAGNM
     C                   EVAL      ADCAFT = AGAGFT
     C                   EVAL      ADCAFN = AGAGFN
 
     C                   UPDATE    LEAGDVD0
     C                   EVAL      WFND01 = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C     KLEDVL3       READE     LEAGDVPD
     C                   ENDDO
     C                   IF        WFND01 = 'N'
      ** Previous Tranche
     C                   EVAL      ADPTBR = AGTRBR
     C                   EVAL      ADPTNM = AGTRNM
     C                   EVAL      ADPTFT = AGTRFT
     C                   EVAL      ADPTFN = AGTRFN
      * Previous Aggregate
     C                   EVAL      ADPABR = *BLANKS
     C                   EVAL      ADPANM = *BLANKS
     C                   EVAL      ADPAFT = 0
     C                   EVAL      ADPAFN = 0
      ** Current Tranche
     C                   EVAL      ADCTBR = AGTRBR
     C                   EVAL      ADCTNM = AGTRNM
     C                   EVAL      ADCTFT = AGTRFT
     C                   EVAL      ADCTFN = AGTRFN
      ** Current Aggregate
     C                   EVAL      ADCABR = AGAGBR
     C                   EVAL      ADCANM = AGAGNM
     C                   EVAL      ADCAFT = AGAGFT
     C                   EVAL      ADCAFN = AGAGFN
     C
     C                   WRITE     LEAGDVD0
     C                   ENDIF
 
     C                   ELSE
      ** Current Tranche
     C                   EVAL      ADCTBR = AGTRBR
     C                   EVAL      ADCTNM = AGTRNM
     C                   EVAL      ADCTFT = AGTRFT
     C                   EVAL      ADCTFN = AGTRFN
      ** Previous Tranche
     C                   EVAL      ADPTBR = *BLANKS
     C                   EVAL      ADPTNM = *BLANKS
     C                   EVAL      ADPTFT = 0
     C                   EVAL      ADPTFN = 0
      * Previous Aggregate
     C                   EVAL      ADPABR = *BLANKS
     C                   EVAL      ADPANM = *BLANKS
     C                   EVAL      ADPAFT = 0
     C                   EVAL      ADPAFN = 0
      ** Current Aggregate
     C                   EVAL      ADCABR = AGAGBR
     C                   EVAL      ADCANM = AGAGNM
     C                   EVAL      ADCAFT = AGAGFT
     C                   EVAL      ADCAFN = AGAGFN
 
     C                   WRITE     LEAGDVD0
 
     C                   ENDIF
     C
     C                   ELSE
      ** Current Tranche
     C                   EVAL      ADCTBR = AGTRBR
     C                   EVAL      ADCTNM = AGTRNM
     C                   EVAL      ADCTFT = AGTRFT
     C                   EVAL      ADCTFN = AGTRFN
      ** Current Aggregate
     C                   EVAL      ADCABR = AGAGBR
     C                   EVAL      ADCANM = AGAGNM
     C                   EVAL      ADCAFT = AGAGFT
     C                   EVAL      ADCAFN = AGAGFN
     C
     C                   UPDATE    LEAGDVD0
     C
     C                   ENDIF
     C
     C                   READ      LETRAGL4
     C
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * READDF - Read Aggregate Structure driving file                *
      *                                                               *
      *****************************************************************
     C     READDF        BEGSR
 
     C     *LOVAL        SETLL     LEAGDVPD
     C                   READ      LEAGDVPD
 
     C                   DOW       NOT %EOF(LEAGDVPD)
 
      ** Insert
     C                   IF        (ADPTBR = ADCABR
     C                             AND ADPTNM = ADCTNM
     C                             AND ADPTFT = ADCTFT
     C                             AND ADPTFN = ADCTFN)
     C                   IF        (ADPABR = *BLANKS
     C                             AND ADPANM = *BLANKS
     C                             AND ADPAFT = 0
     C                             AND ADPAFN = 0)
     C                             AND
     C                             (ADCABR <> *BLANKS
     C                             AND ADCANM <> *BLANKS
     C                             AND ADCAFT <> 0
     C                             AND ADCAFN <> 0)
 
     C                   EVAL      WACTN = 'I'
 
     C                   EXSR      UPDHIST
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Amend
     C                   IF        (ADPTBR = ADCTBR
     C                             AND ADPTNM = ADCTNM
     C                             AND ADPTFT = ADCTFT
     C                             AND ADPTFN = ADCTFN)
 
     C                   IF        (ADPABR <> *BLANKS
     C                             AND ADPANM <> *BLANKS
     C                             AND ADPAFT <> 0
     C                             AND ADPAFN <> 0)
     C                             AND
     C                             (ADCABR <> *BLANKS
     C                             AND ADCANM <> *BLANKS
     C                             AND ADCAFT <> 0
     C                             AND ADCAFN <> 0)
     C
     C                   IF        (ADPABR <> ADCABR
     C                             OR ADPANM <> ADCANM
     C                             OR ADPAFT <> ADCAFT
     C                             OR ADPAFN <> ADCAFN)
 
     C                   EVAL      WACTN = 'A'
 
     C                   EXSR      UPDHIST
 
     C                   ENDIF
 
     C                   ENDIF
     C
     C                   ENDIF
 
      ** Delete
     C                   IF        (ADPTBR <> *BLANKS
     C                             AND ADPTNM <> *BLANKS
     C                             AND ADPTFT <> 0
     C                             AND ADPTFN <> 0)
     C                             AND
     C                             (ADPABR <> *BLANKS
     C                             AND ADPANM <> *BLANKS
     C                             AND ADPAFT <> 0
     C                             AND ADPAFN <> 0)
 
     C                   IF        (ADCTBR = *BLANKS
     C                             AND ADCTNM = *BLANKS
     C                             AND ADCTFT = 0
     C                             AND ADCTFN = 0)
     C                             AND
     C                             (ADCABR = *BLANKS
     C                             AND ADCANM = *BLANKS
     C                             AND ADCAFT = 0
     C                             AND ADCAFN = 0)
     C
     C                   EVAL      WACTN = 'D'
 
     C                   EXSR      UPDHIST
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      LEAGDVPD
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDHIST - Update History File                                 *
      *                                                               *
      *****************************************************************
     C     UPDHIST       BEGSR
 
     C                   SELECT
 
     C                   WHEN      WACTN = 'I'
 
     C     KLEHSL2       CHAIN     LEAGHSL1
     C                   IF        %FOUND(LEAGHSL1)
     C                   DOW       NOT %EOF(LEAGHSL1)
 
      ** Write history record
     C                   EVAL      AIBRCA = ADCABR
     C                   EVAL      AICNUM = ADCANM
     C                   EVAL      AIFCTY = DSACAG
     C                   WRITE     LEAGHSX0
     C
     C     KLEHSL2       READE     LEAGHSL1
     C                   ENDDO
     C                   ENDIF
 
     C                   WHEN      WACTN = 'A'
 
     C     KLEHSL1       CHAIN     LEAGHSL1
     C                   IF        %FOUND(LEAGHSL1)
     C                   DOW       NOT %EOF(LEAGHSL1)
 
      ** Update history record
     C                   EVAL      AIBRCA = ADCABR
     C                   EVAL      AICNUM = ADCANM
     C                   EVAL      AIFCTY = DSFCAG
     C                   UPDATE    LEAGHSD0
 
     C     KLEHSL1       READE     LEAGHSL1
     C                   ENDDO
     C                   ENDIF
 
     C                   WHEN      WACTN = 'D'
 
     C     KLEHSL1       CHAIN     LEAGHSL1
     C                   IF        %FOUND(LEAGHSL1)
     C                   DOW       NOT %EOF(LEAGHSL1)
 
      ** Delete history record
     C                   DELETE    LEAGHSD0
 
     C     KLEHSL1       READE     LEAGHSL1
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Set up copyright parameter
     C                   MOVEA     CPY@          ACT@
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = 'LE000062'
     C                   EVAL      DBMOD = 'LE000062'
     C                   EVAL      DBASE = *ZEROS
     C                   OUT       LDA
 
     C     KLEDVL1       KLIST
     C                   KFLD                    PRV_AGTRBR
     C                   KFLD                    PRV_AGTRNM
     C                   KFLD                    PRV_AGTRFT
     C                   KFLD                    PRV_AGTRFN
     C                   KFLD                    PRV_AGAGBR
     C                   KFLD                    PRV_AGAGNM
     C                   KFLD                    PRV_AGAGFT
     C                   KFLD                    PRV_AGAGFN
 
     C     KLEDVL2       KLIST
     C                   KFLD                    AGTRBR
     C                   KFLD                    AGTRNM
     C                   KFLD                    AGTRFT
     C                   KFLD                    AGTRFN
     C                   KFLD                    AGAGBR
     C                   KFLD                    AGAGNM
     C                   KFLD                    AGAGFT
     C                   KFLD                    AGAGFN
 
     C     KLEDVL3       KLIST
     C                   KFLD                    AGTRBR
     C                   KFLD                    AGTRNM
     C                   KFLD                    AGTRFT
     C                   KFLD                    AGTRFN
 
     C     KLEHSL1       KLIST
     C                   KFLD                    ADPTBR
     C                   KFLD                    ADPTNM
     C                   KFLD                    DSFCTR
     C                   KFLD                    ADPABR
     C                   KFLD                    ADPANM
     C                   KFLD                    DSFCAG
 
     C     KLEHSL2       KLIST
     C                   KFLD                    ADPTBR
     C                   KFLD                    ADPTNM
     C                   KFLD                    DSFCTR
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2011
