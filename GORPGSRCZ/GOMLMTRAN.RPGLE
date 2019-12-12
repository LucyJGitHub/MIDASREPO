     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*USRCTL   )                                          *
/*EXI *  TEXT('Midas GO Housekeeping for T_MLMTRAN')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOMLMTRAN - Housekeeping for T_MLMTRAN                       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD054879           Date 09Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR796237           Date 28Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 BUG4443            Date 04Oct04               *
      *                 BUG3839            Date 28Jul04               *
      *                 BUG3827            Date 27Jul04               *
      *                 BUG3562            Date 12Jul04               *
      *                 CGP003  *CREATE    Date 09Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054879 - Failed when do facility enquiry from TI to Fusion *
      *             Midas                                             *
      *  MD046248 - Finastra Rebranding                               *
      *  AR796237 - GOC0050 00001 (Recompile)                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE106 - Syndications Manager.                               *
      *  BUG4443 - Variable length fields can be of zero length.      *
      *            This means cannot be a substring of the field.     *
      *  BUG3839 - TI manual transactions to be kept indefinitely     *
      *  BUG3827 - Updates to T_MLMTRAN not updating ML or CL exposure*
      *  BUG3562- Null dates on T_MLMTRAN not correctly handled.      *
      *  CGP003 - Management Limits                                   *
      *           Required to move details of manual transactions     *
      *           to the Global Transactions file.                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Record not found on T_MLMTRAN                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************

     F*T_MLMTRAN UF   E             DISK    INFSR(*PSSR)                                     BUG3827
     FT_MLMTRAN UF   E             DISK    INFSR(*PSSR) COMMIT                               BUG3827
     F                                     RENAME(T_MLMTRAN:MLMTRAN)
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)                                      BUG3562

     D @RUN            S              1
     D ZWDTIN          S              8S 0

     D                 DS                                                                   MD054879
     D  RPDAT                  1      6  0                                                  MD054879
     D  RPDTD                  1      2  0                                                  MD054879
     D  RPDTM                  3      4  0                                                  MD054879
     D  RPDTYR                 5      6  0                                                  MD054879
     D WRetYrs         S              1  0                                                  MD054879
     D WRetMnths       S              2  0                                                  MD054879
     D PRTCD           S              7                                                     MD054879
     D WTranRetPrd     S              5  0                                                  MD054879
     D WRetPrdN        S              2  0                                                  MD054879
      ** Parameter variables for access object GPAOSVAL                                     MD054879
     D pSysVal01       S             20    INZ(*BLANKS)                                     MD054879
     D pSysValCurS01   S            200    INZ(*BLANKS)                                     MD054879
     D pSysVal02       S             20    INZ(*BLANKS)                                     MD054879
     D pSysValCurS02   S            200    INZ(*BLANKS)                                     MD054879
     D pSysVal03       S             20    INZ(*BLANKS)                                     MD054879
     D pSysValCurS03   S            200    INZ(*BLANKS)                                     MD054879
     D pSysVal04       S             20    INZ(*BLANKS)                                     MD054879
     D pSysValCurS04   S            200    INZ(*BLANKS)                                     MD054879
     D pSysVal05       S             20    INZ(*BLANKS)                                     MD054879
     D pSysValCurS05   S            200    INZ(*BLANKS)                                     MD054879
     D pSysVal06       S             20    INZ(*BLANKS)                                     MD054879
     D pSysValCurS06   S            200    INZ(*BLANKS)                                     MD054879
     D pSysVal07       S             20    INZ(*BLANKS)                                     MD054879
     D pSysValCurS07   S            200    INZ(*BLANKS)                                     MD054879
     D pSysVal08       S             20    INZ(*BLANKS)                                     MD054879
     D pSysValCurS08   S            200    INZ(*BLANKS)                                     MD054879
     D pSysVal09       S             20    INZ(*BLANKS)                                     MD054879
     D pSysValCurS09   S            200    INZ(*BLANKS)                                     MD054879
     D pSysVal10       S             20    INZ(*BLANKS)                                     MD054879
     D pSysValCurS10   S            200    INZ(*BLANKS)                                     MD054879
                                                                                            MD054879
     C                   READ      T_MLMTRAN                              80
     C     *IN80         DOWEQ     '0'

      * Recover the zone attached to the branch

     C     MTBRCHCODE    CHAIN     SDBRCHD0                           99
      * error
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'BRANCH ' + MTBRCHCODE
     C                              + ' NOT IN GLOBAL LAYER'
     C                   EXSR      *PSSR
     C                   ENDIF

      * Only process records in this zone
     C     O#ZONE        IFEQ      A8ZONE
                                                                                             BUG3562
      * Get the run date                                                                     BUG3562
                                                                                             BUG3562
     C     O#ZONE        CHAIN     SDBANKD0                           99                     BUG3562
      * error                                                                                BUG3562
     C     *IN99         IFEQ      *ON                                                       BUG3562
     C                   EVAL      I#ERMS = 'ZONE' + O#ZONE                                  BUG3562
     C                              + ' NOT IN GLOBAL LAYER'                                 BUG3562
     C                   EXSR      *PSSR                                                     BUG3562
     C                   ENDIF                                                               BUG3562
      * Calculate retention date                                                            MD054879
     C     *IN20         IFEQ      *OFF                                                     MD054879
     C                   SETON                                        20                    MD054879
     C                   EXSR      Calc_Ret                                                 MD054879
     C                   ENDIF                                                              MD054879

      * End Date
     C                   MOVEL     *BLANKS       WORKDATE          8
     C                   EVAL      WORKDATE = %CHAR(MTMATDATE:*ISO0)
     C                   MOVEL     WORKDATE      ZWDTIN
     C     ZWDTIN        IFEQ      00010101                                                  BUG3562
     C                   Z-ADD     *ZERO         T_EDAT                                      BUG3562
     C                   ELSE                                                                BUG3562
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        T_EDAT            5 0            Midas day no.
     C                   ENDIF                                                               BUG3562
                                                                                             BUG3839
      * Source of manual transaction                                                         BUG3839
                                                                                             BUG3839
     C                   MOVE      *BLANK        Source            2                         BUG3839
     C                   MOVE      *ZERO         Length            2 0                       BUG4443
     C                   EVAL      Length = %Len(MTREF)                                      BUG4443
     C     Length        IFGE      2                                                         BUG4443
     C                   EVAL      Source = %Subst(MTREF:1:2)                                BUG3839
     C                   ENDIF                                                               BUG4443

      * Matured?

     C*****T_EDAT********IFLT      O#RDNB                                                    BUG3562
     C     T_EDAT        IFLT      BJRDNB                                                    BUG3562
     C     T_EDAT        ANDNE     *ZERO                                                     BUG3562
     C     Source        ANDNE     'TI'                                                      BUG3839
     C     MTDELETED     OREQ      'Y'
     C     T_EDAT        ORLT      WTranRetPrd                                              MD054879
     C                   DELETE    MLMTRAN
     C                   ELSE

      * Only process if not flagged as live
     C     MTDELETED     IFNE      'L'
      * Value Date
     C                   MOVEL     *BLANKS       WORKDATE          8
     C                   EVAL      WORKDATE = %CHAR(MTVALDATE:*ISO0)
     C                   MOVEL     WORKDATE      ZWDTIN
     C     ZWDTIN        IFEQ      00010101                                                  BUG3562
     C                   Z-ADD     BJRDNB        T_SDAT                                      BUG3562
     C                   ELSE                                                                BUG3562
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        T_SDAT            5 0            Midas day no.
     C                   ENDIF                                                               BUG3562

      * Has this record past value?
      * If it has, update the record to ensure that the trigger has been
      * called to produce the value date records

     C*****T_SDAT********IFLE      O#RDNB                                                    BUG3562
     C     T_SDAT        IFLE      BJRDNB                                                    BUG3562

      * Need to update a field on the file for the update to occur
      * The deleted field is used to show that this transaction is live

     C                   MOVEL     'L'           MTDELETED
     C                   UPDATE    MLMTRAN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
                                                                                             BUG3827
     C                   COMMIT                                                              BUG3827

     C                   READ      T_MLMTRAN                              80
     C                   ENDDO

     C                   RETURN
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C                   MOVEL     *BLANK        I#ERMS           50
      * Get Zone

      /COPY GOCPYSRC,GOGETZONE

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************                     MD054879
                                                                                            MD054879
     C     Calc_Ret      BEGSR                                                              MD054879
                                                                                            MD054879
     C                   EVAL      pSysVal01     = 'ManualTxnRetention'                     MD054879
                                                                                            MD054879
     C                   CALL      'GPAOSVALR0'                                             MD054879
     C                   PARM      *Blank        PRtCd                                      MD054879
     C                   PARM                    pSysVal01                                  MD054879
     C                   PARM                    pSysValCurS01                              MD054879
     C                   PARM                    pSysVal02                                  MD054879
     C                   PARM                    pSysValCurS02                              MD054879
     C                   PARM                    pSysVal03                                  MD054879
     C                   PARM                    pSysValCurS03                              MD054879
     C                   PARM                    pSysVal04                                  MD054879
     C                   PARM                    pSysValCurS04                              MD054879
     C                   PARM                    pSysVal05                                  MD054879
     C                   PARM                    pSysValCurS05                              MD054879
     C                   PARM                    pSysVal06                                  MD054879
     C                   PARM                    pSysValCurS06                              MD054879
     C                   PARM                    pSysVal07                                  MD054879
     C                   PARM                    pSysValCurS07                              MD054879
     C                   PARM                    pSysVal08                                  MD054879
     C                   PARM                    pSysValCurS08                              MD054879
     C                   PARM                    pSysVal09                                  MD054879
     C                   PARM                    pSysValCurS09                              MD054879
     C                   PARM                    pSysVal10                                  MD054879
     C                   PARM                    pSysValCurS10                              MD054879
                                                                                            MD054879
      ** Error routine - Retrieval of SysVal failed                                         MD054879
     C                   IF        PRTCD      <> *BLANKS                                    MD054879
     C                   EXSR      *PSSR                                                    MD054879
     C                   ENDIF                                                              MD054879
                                                                                            MD054879
     C                   MOVEL     pSysValCurS01 WRetPrdN                                   MD054879
      ** Review computation of retention period                                             MD054879
     C     WRetPrdN      DIV       12            WRetYrs                                    MD054879
     C                   MVR                     WRetMnths                                  MD054879
                                                                                            MD054879
      ** Convert rundate date into DDMMYY format and substract the retention                MD054879
      ** period in months (WRetMnths) and yars (WRetYrs) from it                            MD054879
     C                   CALL      'ZDATE2'                                                 MD054879
     C                   PARM      BJRDNB        ZDAYNO            5 0                      MD054879
     C                   PARM                    BJDFIN                                     MD054879
     C                   PARM      0             ZDATE             6 0                      MD054879
     C                   PARM      *Blanks       ZADATE            7                        MD054879
                                                                                            MD054879
     C                   EVAL      RPDAT = ZDATE                                            MD054879
     C                   EVAL      RPDTM = RPDTM - WRetMnths                                MD054879
     C                   EVAL      RPDTYR = RPDTYR - WRetYrs                                MD054879
      ** Check that resutling is valid                                                      MD054879
     C                   IF        RPDTM < 0                                                MD054879
     C                   EVAL      RPDTM = RPDTM + 12                                       MD054879
     C                   EVAL      RPDTYR = RPDTYR -1                                       MD054879
     C                   ENDIF                                                              MD054879
                                                                                            MD054879
      ** Finally convert date back to a day number for further comparison                   MD054879
     C                   MOVEL     RPDAT         ZDATEI                                     MD054879
     C                   Call      'ZDATE1'                                                 MD054879
     C                   PARM                    Error             7                        MD054879
     C                   PARM                    ZDATEI            6 0                      MD054879
     C                   PARM                    BJDFIN                                     MD054879
     C                   PARM      *ZEROS        ZDAYNO                                     MD054879
     C                   EVAL      WTranRetPrd = ZDAYNO                                     MD054879
                                                                                            MD054879
     C                   ENDSR                                                              MD054879
      *****************************************************************                     MD054879
      /SPACE 5                                                                              MD054879
      ********************************************************************
      * ZDATE10
      ********************************************************************
     C     ZDATE10       BEGSR
     C                   CALLB     'ZDATE10'
     C                   PARM                    ZWDTIN
     C                   PARM                    ZZMDNO            5 0
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
