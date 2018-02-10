     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Generate deal amendment sequence number')     *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *     MM0085 - GENERATE DEAL AMENDMENT SEQUENCE NUMBER          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 203677             Date 15May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 03Sep97               *
      *                 S01194             Date 19MAR90               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *           Recompile due to changes in MMDEAMPP.               *
      *  203677 - Job DBU_DEAM attempted to write duplicate record to *
      *           file MMDEMULL.  PF/MMVDEAMPP should also be checked *
      *           in generating deal amendment sequence number.       *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *  S01194 - REL 10 COPYRIGHT STATEMENTS                         *
      *                                                               *
      *****************************************************************
     F*                                                              *
     F* ID F  C  H  L     FUNCTION OF INDICATORS
     F* ----------------------------------------
     F*
     F*       10          BEGINNING OF FILE INDICATOR
     F*
     F*****************************************************************
     F***MMDEAMLL**IF***E           K DISK    INFSR(*PSSR)                                    203677
     FMMDEAML2  IF   E           K DISK    INFSR(*PSSR)                                       203677
     F                                     USROPN
     F/COPY WNCPYSRC,MM0085F001
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)                               S01
     D* ARRAY FOR COPYRIGHT STATEMENT                                     S01194
     D*
     D PSDS           SDS
     D*
     D**  PROGRAM STATUS DATA STRUCTURE
     D  @JOB                 244    253
     D  @USER                254    263
     D                UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183
     D*
     D**  VALUE DATE DATA STRUCTURE
     D @VDDS           DS
     D  @VDATE                 1      8  0
     D  HNVDYY                 1      4  0
     D  HNVDMM                 5      6  0
     D  HNVDDD                 7      8  0
      *                                                                                       203677
     D @VDDS2          DS                                                                     203677
     D  @VDATE2                1      8  0                                                    203677
     D  IGVDYY                 1      4  0                                                    203677
     D  IGVDMM                 5      6  0                                                    203677
     D  IGVDDD                 7      8  0                                                    203677
     D*
     D**  INPUT VALUE DATE DATA STRUCTURE
     D @IVDDS          DS
     D  @IVDAT                 1      8  0
     D  @VDATY                 1      4  0
     D  @VDATM                 5      6  0
     D  @VDATD                 7      8  0
      **
      ** DEAM Sequence Number passed as a parameter.
     D @AMSQN          S              3P 0
      **
     C/EJECT
     C*
     C*
     C     @TERM         IFNE      'T'                                          B1
     C                   EXSR      #A                                           *1
     C*
     C     @TERM         IFNE      'E'                                          B*2
     C                   EXSR      #B                                           **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C*
     C                   EXSR      #C
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*     INDEX TO SUBROUTINES                                     *
     C*                                                              *
     C*  1. #B     - MAIN PROCESSING                                 *
     C*  3. #A     - INITIAL PROCESSING                              *
     C*  3. #C     - TERMINATION PROCESSING                          *
     C*  4. *PSSR  - DUMP                                            *
     C*                                                              *
     C****************************************************************
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*     #B - MAIN PROCESSING                                     *
     C*                                                              *
     C*     CALLED BY  : CONTROL PROCESSING                          *
     C*                                                              *
     C*     CALLS      :                                             *
     C*                                                              *
     C*     WORK FIELDS: @DEALN   DEAL NUMBER                   (6N) *
     C*                  @IVDAT   VALUE DATE                    (8N) *
     C*                  @AMSQN   DEAL AMENDMENT SEQUENCE NUMBER(3N) *
     C*                                                              *
     C****************************************************************
     C*
     C     #B            BEGSR
     C*
     C**  SET UP KEY TO ACCESS DEAL AMENDMENTS FILE
     C                   MOVE      @VDAT         @IVDDS
     C                   Z-ADD     999           @AMSQN
     C                   MOVE      *BLANKS       @VDATE                                       203677
     C                   MOVE      *BLANKS       @VDATE2                                      203677
     C*
     C     @KEY          KLIST
     C                   KFLD                    @DEALN
     C                   KFLD                    @VDATY
     C                   KFLD                    @VDATM
     C                   KFLD                    @VDATD
     C                   KFLD                    @AMSQN
     C*
     C**  POSITION FILE POINTER AFTER RECORDS MATCHING KEY
     C*****@KEY*         SETGT     MMDEAMLL                                                   203677
     C     @KEY          SETGT     MMDEAML2                                                   203677
     C*
     C**  READ PREVIOUS RECORD
     C**********         READP     MMDEAMLL                               10                  203677
     C                   READP     MMDEAML2                               10                  203677
     C*
     C**  IF *IN10 IS ON, BEGINNING OF FILE HAS BEEN REACHED AND
     C**  DEAL AMENDMENT SEQUENCE NUMBER IS 001
     C     *IN10         IFEQ      '1'                                          B1
     C                   Z-ADD     1             @AMSQN                         *1
     C                   GOTO      #B9                                          *1
     C                   END                                                    E1
     C*
     C**  IF DEAL NUMBER AND VALUE DATE ON RECORD ARE EQUAL TO
     C**  INPUT PARAMETERS, NEW DEAL AMENDMENT SEQUENCE NUMBER
     C**  IS DEAL AMENDMENT SEQUENCE NUMBER ON RECORD INCREMENTED
     C**  BY 1
     C     @DEALN        IFEQ      HNDA38                                       B1
     C     @IVDAT        ANDEQ     @VDATE                                       *1
      *                                                                                       203677
     C     HNDS38        ADD       1             @AMSQN                         *1
      *                                                                                       203677
     C                   ELSE                                                                 203677
     C     @DEALN        IFEQ      IGDA38                                                     203677
     C     @IVDAT        ANDEQ     @VDATE2                                                    203677
      *                                                                                       203677
     C     IGDS38        ADD       1             @AMSQN                         *1            203677
     C*
     C**  IF DEAL NUMBER AND VALUE DATE ARE NOT EQUAL TO INPUT
     C**  PARAMETERS, DEAL AMENDMENT SEQUENCE NUMBER IS 001
     C                   ELSE                                                   X1
     C                   Z-ADD     1             @AMSQN                         *1
     C                   END                                                    E1
     C                   ENDIF                                                                203677
     C*
     C/COPY WNCPYSRC,MM0085C001
     C     #B9           ENDSR
     C*
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*     #A - INITIAL PROCESSING                                  *
     C*                                                              *
     C*     CALLED BY  : CONTROL PROCESSING                          *
     C*                                                              *
     C*     CALLS      :                                             *
     C*                                                              *
     C*     WORK FIELDS: @DEALN   DEAL NUMBER                   (6N) *
     C*                  @VDAT    VALUE DATE                    (8N) *
     C*                  @AMSQN   DEAL AMENDMENT SEQUENCE NUMBER(3N) *
     C*                  @TERM    TERMINATION CODE              (1A) *
     C*                                                              *
     C****************************************************************
     C*
     C     #A            BEGSR
     C*
     C**  RECEIVE PARAMETERS - DEAL NUMBER AND VALUE DATE
     C     *ENTRY        PLIST
     C                   PARM                    @TERM             1
     C                   PARM                    @DEALN            6 0
     C                   PARM                    @VDAT             8 0
     C                   PARM                    @AMSQN
     C*
     C                   MOVEA     CPY@          BIS@             80                           S0119
     C*
     C**  OPEN MMDEAMLL ONCE ONLY
     C**********         OPEN      MMDEAMLL                                                   203677
     C                   OPEN      MMDEAML2                                                   203677
     C*
     C     #A9           ENDSR
     C*
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*     #C - TERMINATION PROCESSING                              *
     C*                                                              *
     C*     CALLED BY  : CONTROL PROCESSING                          *
     C*                                                              *
     C*     CALLS      :                                             *
     C*                                                              *
     C*     WORK FIELDS:                                             *
     C*                                                              *
     C****************************************************************
     C*
     C     #C            BEGSR
     C*
     C**  IF THIS PROGRAM CALLED WITH @TERM = T, TERMINATE PROGRAM
     C     @TERM         IFEQ      'T'                                          B1
     C                   MOVE      '1'           *INLR                          *1
     C                   GOTO      #C9                                          *1
     C                   END                                                    E1
     C*
     C**  SET UP PROGRAM NAME
     C                   MOVEL     'MM0085'      DBPGM
     C*
     C**  CLOSE FILE UNDER USER CONTROL
     C**********         CLOSE     MMDEAMLL                                                   203677
     C                   CLOSE     MMDEAML2                                                   203677
     C*
     C**  RETURN TO CALLING PROGRAM
     C                   RETURN
     C*
     C     #C9           ENDSR
     C*
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*      EXCEPTION ERROR SUBROUTINE                               *
     C*                                                               *
     C*      SUBROUTINE CALLED: EXECUTES WHENEVER EITHER FILE OR      *
     C*                         PROGRAM ERROR OCCURS                  *
     C*                                                               *
     C*      CALLS            :                                       *
     C*                                                               *
     C*****************************************************************
     C*
     C     *PSSR         BEGSR
     C*
     C**  SET @ERR1 TO 'Y' TO PREVENT LOOPING IF FURTHER ERRORS
     C     @ERR1         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @ERR1             1            *1
     C                   MOVE      '1'           *INU6                          *1
     C*
     C**  SET UP FIELDS IN LOCAL DATA AREA
     C                   MOVE      'MM0085'      DBPGM                          *1
     C                   MOVE      '991'         DBASE                          *1
     C                   MOVE      'E'           @TERM                          *1
     C                   DUMP                                                   *1
     C                   END                                                    E1
     C*
     C                   MOVE      '1'           *INLR
     C                   ENDSR
     C*
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
