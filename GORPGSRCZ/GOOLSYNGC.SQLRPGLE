     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *          MD055682
/*STD *  RPGSQLMOD                                                    *          MD055682
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *          MD055682
/*EXI *  TEXT('Midas GO On-Line Synch. of Global Layer Cntllr')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOOLSYNGC - On-Line Synchronisation of Global Layer Cntllr   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055682           Date 31Jul20               *
      *  Prev Amend No. MD055132           Date 30Jan20               *
      *                 MD046248           Date 27Oct17               *
      *                 CAP210             Date 28Sep12               *
      *                 AR1064975          Date 05Dec12               *
      *                 AR1004827          Date 30Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16177A          Date 08Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BG5090R            Date 05Apr05               *
      *                 BUG3379            Date 24Jun04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055682 - Deliverable Data Split for TRIG                   *
      *  MD055132 - GO_ONL_SYN Array index is out of range            *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *           Issue when filename is equal to 10 characters       *
      *  AR1064975 -  Issue on GO_ONL_SYN                             *
      *  AR1004827 - Global updater stops immediately/fails when      *
      *              receiver changes (BUG16177A incomplete)          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16177A- Background job EQ_ONL_SYN is not working          *
      *  BG5090R - Remove sequence number processing                  *
      *  BUG3379 - Stop duplicate updating of files by only applying  *
      *            first trigger to file.                             *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     FGPGLOBFL0 IF   E           K DISK    INFSR(*PSSR)
     F*SCTRIGL1* IF   E           K DISK    INFSR(*PSSR)                                    MD055682
     FGPSOLOGPD O  A E             DISK    INFSR(*PSSR)
     FGOOSJSPD  IF   E             DISK    INFSR(*PSSR)                                    BUG16177A


     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS


      * Maximum number of files
     D***MaxNoFils       C                   CONST(200)                                     MD055132
     D MaxNoFils       C                   CONST(999)                                       MD055132
      * File array
     D #_ZPF           S             10    DIM(MaxNoFils)


     D #_RCV1          S              1    DIM(30) CTDATA PERRCD(30)
     D***#_RCV2*         S              1    DIM(180) CTDATA PERRCD(60)                    AR1004827
     D #_RCV2          S              1    DIM(210) CTDATA PERRCD(70)                      AR1004827
     D RCVJRNE         S              1    DIM(2500)
     D #CNT            S              3P 0                                                    CAP210
     D #TEMPVAL        S           2500A                                                      CAP210
     D SCTRIG        E DS                  EXTNAME(SCTRGJW0)                                MD055682


     C     *ENTRY        PLIST
     C                   PARM                    JRNSEQA          10
     C                   PARM                    JRNRCVR          10                       BUG16177A

      * Move in files

     C                   MOVEA     #_RCV1        RCVJRNE(1)
     C**********         MOVEA     #_ZPF         RCVJRNE(25)                                  CAP210
      *                                                                                       CAP210
      ** Initialize temporary values                                                          CAP210
      *                                                                                       CAP210
     C                   EVAL      #TEMPVAL = *BLANKS                                         CAP210
     C                   EVAL      #CNT = 1                                                   CAP210
     C                   DOW       #_ZPF(#CNT) <> *BLANKS                                     CAP210
     C                             OR #CNT > MaxNoFils                                        CAP210
      *                                                                                       CAP210
      ** Always pad a single space in between the filenames                                   CAP210
      *                                                                                       CAP210
     C                   IF        #CNT <> 1                                                  CAP210
     C                   EVAL      #TEMPVAL = %TRIM(#TEMPVAL) + ' '                           CAP210
     C                                        + #_ZPF(#CNT)                                   CAP210
     C                   ELSE                                                                 CAP210
     C                   EVAL      #TEMPVAL =  #_ZPF(#CNT)                                    CAP210
     C                   ENDIF                                                                CAP210
     C                   EVAL      #CNT = #CNT + 1                                            CAP210
     C                   ENDDO                                                                CAP210
     C                   MOVEA     #TEMPVAL      RCVJRNE(25)                                  CAP210

      * Find end of files

     C                   Z-ADD     1             @T
     C     '!'           LOOKUP    RCVJRNE(@T)                            99    *
     C                   MOVEA     #_RCV2        RCVJRNE(@T)
                                                                                           AR1004827
      ** Find journal receiver                                                             AR1004827
                                                                                           AR1004827
     C                   Z-ADD     1             @T                                        AR1004827
     C     '!'           LOOKUP    RCVJRNE(@T)                            99    *          AR1004827
     C                   MOVEA     JRNRCVR       RCVJRNE(@T)                               AR1004827

      * Find journal sequence number

     C                   Z-ADD     1             @T
     C     '!'           LOOKUP    RCVJRNE(@T)                            99    *
     C                   MOVEA     JRNSEQA       RCVJRNE(@T)

      * Find end of command

     C                   Z-ADD     1             @T
     C     '!'           LOOKUP    RCVJRNE(@T)                            99    *
     C                   MOVE      ' '           RCVJRNE(@T)

      * Execute RCVJRNE

     C                   Z-ADD     @T            #MesLen          15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    RCVJRNE
     C                   PARM                    #MesLen

      **If*Journal*Receiver*have*change*pass*it*back**********************       BUG16177A AR1004827
     C*****1****         CHAIN(E)  GOOSJSPD                                      BUG16177A AR1004827
     C**********         IF        JRNRCVR <> I#LASTRCV                          BUG16177A AR1004827
     C**********         EVAL      JRNRCVR = I#LASTRCV                           BUG16177A AR1004827
     C**********         EVAL      *INU6 = '1'                                   BUG16177A AR1004827
     C**********         Endif                                                   BUG16177A AR1004827

      * 'Normal' return

     C                   SETON                                        LR
     C                   RETURN

      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Load files for on-line synchronisation
      *********************************************************************
     C     LOAD_FILES    BEGSR

      * Read all global 'GZ' files

     C     *LOVAL        SETLL     GPGLOBFD0
     C                   READ      GPGLOBFD0                              99    *
     C     *IN99         DOWEQ     '0'

      * If on-line synchronisation is required for the file
      * (GFOLSY = T (trigger), B (background) or N (None))

     C     GFOLSY        IFEQ      'T'
     C     GFOLSY        OREQ      'B'

      * Check the triggers on the file

     C                   EXSR      CHK_TRIGGERS

      * As long as triggers are not active for the file
      *  Include the file in the list of files for on-line synchronisation

     C     TriggersActiv IFEQ      'N'

     C                   Z-ADD     1             @T                5 0
     C     GFZPF         LOOKUP    #_ZPF(@T)                              99    *

     C     *in99         ifeq      '0'
     C                   Z-ADD     1             @T
     C     *BLANK        LOOKUP    #_ZPF(@T)                              99    *
     C                   MOVEL     GFZPF         #_ZPF(@T)
     C                   endif

     C                   ENDIF
     C                   ENDIF

     C                   READ      GPGLOBFD0                              99    *
     C                   ENDDO

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Check triggers
      *********************************************************************
     C     CHK_TRIGGERS  BEGSR

     C     SCTRIGK       KLIST
     C                   KFLD                    TR_FILE          10
     C                   KFLD                    TR_PROG          10
     C                   KFLD                    TR_TRTM           1
     C                   KFLD                    TR_TREV           1
     C                   EVAL      TR_FILE = GFZPF
     C                   EVAL      TR_PROG = 'GOGLOB' + GFMOD

      * Insert trigger
     C                   EVAL      TR_TRTM = 'A'
     C                   EVAL      TR_TREV = 'I'
     C*****SCTRIGK       CHAIN     SCTRIGD0                           99        *           MD055682
     C/EXEC SQL                                                                             MD055682
     C+ SELECT *                                                                            MD055682
     C+ into :SCTRIG                                                                        MD055682
     C+ from SCTRGJW0                                                                       MD055682
     C+ where TRFILE = :TR_FILE and TRPGM  = :TR_PROG                                       MD055682
     C+   and TRTIME = :TR_TRTM and TREVNT = :TR_TREV                                       MD055682
     C/END-EXEC                                                                             MD055682
                                                                                              BG5090
     C******             EVAL      TRSEQ = '01'                                               BG5090
     C                   ExSr      Trig_Name                                                  BG5090
     C                   CALL      'SCCHKTRIG'
     C                   PARM                    TR_FILE          10
     C                   PARM                    TR_NAME         258                          BG5090
     C******             PARM                    TR_TRTM           1                          BG5090
     C******             PARM                    TR_TREV           1                          BG5090
     C******             PARM      TRSEQ         TR_TSEQ           2                          BG5090
     C                   PARM      'N'           TR_TRGACTI        1
     C******             PARM      0             TR_TRGCNTI        2 0                        BG5090

      * Update trigger
     C                   EVAL      TR_TRTM = 'A'
     C                   EVAL      TR_TREV = 'U'
     C                   Clear                   TR_NAME                                      BG5090
     C                   Clear                   TIME             10                          BG5090
     C                   Clear                   EVNT             10                          BG5090
     C*****SCTRIGK       CHAIN     SCTRIGD0                           99        *           MD055682
     C/EXEC SQL                                                                             MD055682
     C+ SELECT *                                                                            MD055682
     C+ into :SCTRIG                                                                        MD055682
     C+ from SCTRGJW0                                                                       MD055682
     C+ where TRFILE = :TR_FILE and TRPGM  = :TR_PROG                                       MD055682
     C+   and TRTIME = :TR_TRTM and TREVNT = :TR_TREV                                       MD055682
     C/END-EXEC                                                                             MD055682
     C                   ExSr      Trig_Name                                                  BG5090
     C******             EVAL      TRSEQ = '01'                                              BUG3379
     C                   CALL      'SCCHKTRIG'
     C                   PARM                    TR_FILE
     C                   PARM                    TR_NAME                                      BG5090
     C******             PARM                    TR_TRTM                                      BG5090
     C******             PARM                    TR_TREV                                      BG5090
     C******             PARM      TRSEQ         TR_TSEQ                                      BG5090
     C                   PARM      'N'           TR_TRGACTU        1
     C******             PARM      0             TR_TRGCNTU        2 0                        BG5090

      * Delete trigger
     C                   EVAL      TR_TRTM = 'A'
     C                   EVAL      TR_TREV = 'D'
     C*****SCTRIGK       CHAIN     SCTRIGD0                           99        *           MD055682
     C/EXEC SQL                                                                             MD055682
     C+ SELECT *                                                                            MD055682
     C+ into :SCTRIG                                                                        MD055682
     C+ from SCTRGJW0                                                                       MD055682
     C+ where TRFILE = :TR_FILE and TRPGM  = :TR_PROG                                       MD055682
     C+   and TRTIME = :TR_TRTM and TREVNT = :TR_TREV                                       MD055682
     C/END-EXEC                                                                             MD055682
     C                   ExSr      Trig_Name                                                  BG5090
     C******             EVAL      TRSEQ = '01'                                              BUG3379
     C                   CALL      'SCCHKTRIG'
     C                   PARM                    TR_FILE
     C                   PARM                    TR_NAME                                      BG5090
     C******             PARM                    TR_TRTM                                      BG5090
     C******             PARM                    TR_TREV                                      BG5090
     C******             PARM      TRSEQ         TR_TSEQ                                      BG5090
     C                   PARM      'N'           TR_TRGACTD        1
     C******             PARM      0             TR_TRGCNTD        2 0                        BG5090

     C     TR_TRGACTI    IFEQ      'Y'
     C     TR_TRGACTU    ANDEQ     'Y'
     C     TR_TRGACTD    ANDEQ     'Y'
     C                   MOVEL     'Y'           TriggersActiv     1
     C                   ELSE
     C                   MOVEL     'N'           TriggersActiv
     C                   ENDIF

      * Triggers that are missing

     C     GFOLSY        IFEQ      'T'
     C     TR_TRGACTI    IFEQ      'N'
     C                   EVAL      OSMSG = 'INSERT TRIGGER MISSING:' + GFZPF
     C                   EXSR      WRITE_LOG
     C                   ENDIF
     C     TR_TRGACTU    IFEQ      'N'
     C                   EVAL      OSMSG = 'UPDATE TRIGGER MISSING:' + GFZPF
     C                   EXSR      WRITE_LOG
     C                   ENDIF
     C     TR_TRGACTD    IFEQ      'N'
     C                   EVAL      OSMSG = 'DELETE TRIGGER MISSING:' + GFZPF
     C                   EXSR      WRITE_LOG
     C                   ENDIF
     C                   ENDIF

      * Triggers that shouldn't be present

     C     GFOLSY        IFEQ      'B'
     C     TR_TRGACTI    IFEQ      'Y'
     C                   EVAL      OSMSG = 'INSERT TRIGGER INVALID:' + GFZPF
     C                   EXSR      WRITE_LOG
     C                   ENDIF
     C     TR_TRGACTU    IFEQ      'Y'
     C                   EVAL      OSMSG = 'UPDATE TRIGGER INVALID:' + GFZPF
     C                   EXSR      WRITE_LOG
     C                   ENDIF
     C     TR_TRGACTD    IFEQ      'Y'
     C                   EVAL      OSMSG = 'DELETE TRIGGER INVALID:' + GFZPF
     C                   EXSR      WRITE_LOG
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Write to the log file
      *********************************************************************
     C     WRITE_LOG     BEGSR
     C                   TIME                    TimeDate         12 0
     C                   MOVE      TimeDate      OSDATE
     C                   MOVEL     TimeDate      OSTIME
     C                   WRITE     GPSOLOGD0
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR

     C                   MOVE      *BLANK        I#RTCD            7
     C                   MOVE      *BLANK        I#ERMS           50

      * Job details

     C                   EVAL      OSJOB  = PSJobName
     C                   EVAL      OSUSER = PSUser
     C                   MOVEL     PSJobNo       PSJobNoA          6
     C                   EVAL      OSJOBN = PSJobNoA

      * Load files for on-line synchronisation

     C                   EXSR      LOAD_FILES


      * If no files to monitor then end

     C     #_ZPF(1)      IFEQ      *BLANK
     C                   EVAL      OSMSG = 'On-line Synchronisation not STARTED'
     C                                   + ' as there are no files to monitor'
     C                   EXSR      WRITE_LOG
     C                   SETON                                        LR
     C                   RETURN
     C                   ELSE

      * Record start of function

     C                   EVAL      OSMSG = 'On-line Synchronisation to START'
     C                   EXSR      WRITE_LOG
      * Log files to monitor
     C                   MOVEA     #_ZPF(1)      FileList         40
     C                   EVAL      OSMSG = 'Files:' + FileList
     C                   EXSR      WRITE_LOG
     C                   Z-ADD     5             @T
     C     #_ZPF(@T)     DOWNE     *BLANK
     C                   MOVEA     #_ZPF(@T)     FileList
     C                   EVAL      OSMSG = '      ' + FileList
     C                   EXSR      WRITE_LOG
     C                   ADD       4             @T
     C                   ENDDO
     C                   ENDIF

      * End of file marker

     C                   Z-ADD     1             @T
     C     *BLANK        LOOKUP    #_ZPF(@T)                              99    *
     C                   MOVEL     '!'           #_ZPF(@T)

     C                   ENDSR
      *********************************************************************
      * Trig_Name - Create trigger name                                                       BG5090
      *********************************************************************                   BG5090
     C     Trig_Name     BegSr                                                                BG5090
     C                   IF        TRTIME = 'A'                                               BG5090
     C                   Eval      Time = 'AFTER'                                             BG5090
     C                   EndIf                                                                BG5090
     C                   If        TRTIME = 'B'                                               BG5090
     C                   Eval      Time = 'BEFORE'                                            BG5090
     C                   EndIf                                                                BG5090
     C                   If        TREVNT = 'I'                                               BG5090
     C                   Eval      EVNT = 'INSERT'                                            BG5090
     C                   EndIf                                                                BG5090
     C                   If        TREVNT = 'D'                                               BG5090
     C                   Eval      EVNT = 'DELETE'                                            BG5090
     C                   EndIf                                                                BG5090
     C                   If        TREVNT = 'U'                                               BG5090
     C                   Eval      EVNT = 'UPDATE'                                            BG5090
     C                   EndIf                                                                BG5090
     C                   If        TREVNT = 'R'                                               BG5090
     C                   Eval      EVNT = 'READ'                                              BG5090
     C                   EndIf                                                                BG5090
     C                   EVAL      TR_NAME = %Trim(TRFILE) + '_' +                            BG5090
     C                             %Trim(TIME) + '_' + EVNT                                   BG5090
                                                                                              BG5090
     C                   ENDSR                                                                BG5090
      *********************************************************************                   BG5090
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
** #_RCV1
RCVJRNE JRN(ICJRN) FILE(
** #_RCV2
) EXITPGM(GOOLSYNGZ) RCVRNG(!XXXXXXXXX) FROMENT(!000000000)                                AR1064975
JRNCDE((R) (C *IGNFILSLT) (U *IGNFILSLT) (J *IGNFILSLT))
ENTFMT(*TYPE1) DELAY(*NEXTENT) !
