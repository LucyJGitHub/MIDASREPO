     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBI *  OVRDBF FILE(UPJTNNQT) TOFILE(*LIBL/UPJT01PD)                 *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Remove first lines from spool files')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP0400 - Remove first lines from spool files                 *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Prev Amend No. CUP009  *CREATE    Date 14Aug00               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  CUP009 - Creation of CMPOUTQ command.  This is a re-write    *
      *            of CMPCOB.                                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Database version of spool file
     FUPJTNNQT  UF   E             DISK
      **
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    NotRptLin         1 0
 
      ** Read first record;
     C                   READ      UPJTNNQT                             9899
     C     *IN99         IFEQ      *ON                                          I01
     C                   GOTO      ENDPGM
     C                   ENDIF                                                  E01
     C     *IN98         IFEQ      *ON                                          I01
     C                   EXSR      Error
     C                   ENDIF                                                  E01
 
      ** As this the first record then assume that this is the first line of the header.  Save
      **  this value and then delete appropriate number of records.
     C                   MOVEL     JT1           FirstRec        136
      ** Check if this record contains a page reference as this will be different for each page
     C     'PAGE '       SCAN      FirstRec:1    StrPos            3 0
     C     StrPos        IFEQ      0                                            I01
     C     'Page '       SCAN      FirstRec:1    StrPos
     C                   ENDIF                                                  E01
      ** If 'Page' is found then substring the record up to this value
     C     StrPos        IFNE      0                                            I01
     C                   SETON                                        20
     C     StrPos        ADD       4             Length            3 0
     C     Length        SUBST     FirstRec:1    MinusPage       132
      * else move dummy value into MinusPage so that it will never be blank
     C                   ELSE                                                   X01
     C                   MOVE      'X'           MinusPage
     C                   ENDIF                                                  E01
 
     C                   SETON                                        10
 
     C                   DOU       *IN99 = *ON                                  D01
 
     C     *IN10         IFEQ      *ON                                          I01
     C                   EXSR      DeleteRec
     C                   ENDIF                                                  E01
 
     C     *IN10         IFEQ      *OFF                                         I01
     C                   READ      UPJTNNQT                               99
     C     *IN99         IFEQ      *ON                                          I02
     C                   GOTO      ENDPGM
     C                   ENDIF                                                  E02
     C     *IN98         IFEQ      *ON                                          I02
     C                   EXSR      Error
     C                   ENDIF                                                  E02
     C     *IN20         IFEQ      *ON                                          I02
     C     Length        SUBST     JT1:1         SubstrRec       132
     C                   ENDIF                                                  E02
     C
     C     JT1           IFEQ      FirstRec                                     I02
     C     SubstrRec     OREQ      MinusPage                                     02
     C                   SETON                                        10
     C                   ENDIF                                                  E02
     C                   ENDIF                                                  E01
 
     C                   ENDDO                                                  ED01
 
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
 
      **************************************************************************
      * DeleteRec Subroutine                                                   *
      * This subroutine will delete the number of records from UPJTNNQT as     *
      * specified in the input parameter.                                      *
      * If the routine can not be completed (either end of file or it reaches  *
      * a "header" record) then it will exit.                                  *
      **************************************************************************
 
     C     DeleteRec     BEGSR
 
     C                   SETOFF                                       10
 
     C     1             DO        NotRptLin                                    D02
 
     C                   DELETE    UPJTNNQT                             98
     C     *IN98         IFEQ      *ON                                          I01
     C                   EXSR      Error
     C                   ENDIF                                                  E01
     C                   READ      UPJTNNQT                             9899
     C     *IN20         IFEQ      *ON                                          I01
     C     Length        SUBST     JT1:1         SubstrRec       132
     C                   ENDIF                                                  E01
 
      ** If record equals the first record then exit subroutine
     C     JT1           IFEQ      FirstRec                                     I01
     C     SubstrRec     OREQ      MinusPage                                     01
     C                   SETON                                        10
     C                   GOTO      EndDeleteRec
     C                   ENDIF                                                  E01
 
     C     *IN99         IFEQ      *ON                                          I01
     C                   GOTO      ENDPGM
     C                   ENDIF                                                  E01
     C     *IN98         IFEQ      *ON                                          I01
     C                   EXSR      Error
     C                   ENDIF                                                  E01
     C                   ENDDO                                                  ED02
 
     C     EndDeleteRec  ENDSR
      **************************************************************************
      * Error Subroutine                                                       *
      **************************************************************************
     C     Error         BEGSR
 
     C                   SETON                                        U7U8
     C                   GOTO      ENDPGM
 
     C                   ENDSR
      **************************************************************************
**CTDATA cpy@
(c) Finastra International Limited 2001
