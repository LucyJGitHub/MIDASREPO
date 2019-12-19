     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GO Check RC Awaiting Download')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO000138 - Midas GO Check RC Awaiting Download               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD020167           Date 23Apr13               *
      *                 CCB023A            Date 06Aug12               *
      *                 AR1092060          Date 27Feb13               *
      *                 AR1089839          Date 19Feb13               *
      *                 CCB023  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  CCB023A - COB Restructure - Input Cycle Termination          *
      *            Restructuring                                      *
      *  AR1092060 - GO000138 Error encountered before starting       *
      *              GN EN zone COB (clean cob)                       *
      *  AR1089839 - COBOP and 2.1 source clashes                     *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring                                       *
      *                                                               *
      *****************************************************************
     F***RCLDGRL3  IF   E           K DISK                                                   CCB023A
     F***RCIXI2L3  IF   E           K DISK                                                   CCB023A
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)                                    AR1092060
      *                                                                                    AR1092060
     D/COPY ZACPYSRC,PSDS                                                                  AR1092060
      *
      ** Declared variables
      *
     D SVALK1          S             20
     D SVAL1           S            200
     D*BIS@*****       S             80                                                      CCB023A
     D Value           S              5                                                    AR1092060
     D*LDADS****       DS           256                                                      CCB023A
     D**DBFILE**             134    141                                                      CCB023A
     D**DBKEY***             142    170                                                      CCB023A
     D**DBPGM***             171    180                                                      CCB023A
     D**DBASE***             181    183  0                                                   CCB023A
     D                 DS                                                                  AR1092060
     D  CNT1                   1      5  0                                                 AR1092060
     D  CNT1A                  1      5                                                    AR1092060
     D                 DS                                                                  AR1092060
     D  CNT2                   1      5  0                                                 AR1092060
     D  CNT2A                  1      5                                                    AR1092060
      *
      ** Initialize variables
      *
     C/COPY GOCPYSRC,GOUPD_PARM                                                            AR1092060
      *                                                                                    AR1092060
     C                   IF        Key_Desc = 'WaitRCDownload'                             AR1092060
     C                   EVAL      SVALK1= 'ReopenAutoRecs'
     C******LIKE         DEFINE    LDADS         LDA                                         CCB023A
      *
      ** Determine whether details are awaiting download.
      ** Allow re-open if found.
      *
     C******LOVAL        SETLL     RCLDGRL3                           01                   AR1092060
     C**********         IF        *IN01 = *ON                                             AR1092060
     C******LOVAL        SETLL     RCIXI2L3                           01                   AR1092060
     C**********         ENDIF                                                             AR1092060
      *                                                                                    AR1092060
     C/EXEC SQL                                                                            AR1092060
     C+ SELECT COUNT(*) INTO :CNT1 FROM RCLDGRPD WHERE                                     AR1092060
     C+ R1RPTS = 'C' OR R1RPTS = 'R'                                                       AR1092060
     C/END-EXEC                                                                            AR1092060
     C                   IF        SQLCOD <> 0                                             AR1092060
     C                   EXSR      *PSSR                                                   AR1092060
     C                   ENDIF                                                             AR1092060
      *                                                                                    AR1092060
     C                   IF        CNT1 = 0                                                AR1092060
      *                                                                                    AR1092060
     C/EXEC SQL                                                                            AR1092060
     C+ SELECT COUNT(*) INTO :CNT2 FROM MSIXI2PD WHERE                                     AR1092060
     C+ R3RPTS = 'A' OR R3RPTS = 'R'                                                       AR1092060
     C/END-EXEC                                                                            AR1092060
     C                   IF        SQLCOD <> 0                                             AR1092060
     C                   EXSR      *PSSR                                                   AR1092060
     C                   ENDIF                                                             AR1092060
      *
     C                   ENDIF                                                             AR1092060
      *                                                                                    AR1092060
     C                   IF        CNT1 > 0                                                AR1092060
     C                   EVAL      Value = CNT1A                                           AR1092060
     C                   ELSE                                                              AR1092060
     C                   IF        CNT2 > 0                                                AR1092060
     C                   EVAL      Value = CNT2A                                           AR1092060
     C                   ENDIF                                                             AR1092060
     C                   ENDIF                                                             AR1092060
      *                                                                                    AR1092060
     C**********         IF        *IN01 = *OFF                                            AR1092060
     C                   IF        Value <> '0'                                            AR1092060
      *
      ** Get 'ReopenSwiftTrans' system value from file SDSVALPD
      *
     C/EXEC SQL
     C+ Declare SCursor Insensitive scroll cursor for
     C**SELECT*GIVAL FROM SDSVALPD WHERE                                                    MD054605
     C+ SELECT GIVAL FROM SDSVLJW0 WHERE                                                    MD054605
     C+ GISVAL = :SVALK1
     C/END-EXEC
      *
     C/EXEC SQL
     C+ Open SCursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ FETCH NEXT FROM SCursor INTO :SVAL1
     C/END-EXEC
      *
      ** If the 'ReopenAutoRecs' system value
      ** is missing then end abnormally
      *
     C**********         IF        SQLCOD <> 0 OR                                          AR1092060
     C**********                   %SUBST(SVAL1:1:1) <> 'N'                                AR1092060
     C                   IF        SQLCOD <> 0                                             AR1092060
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/EXEC SQL
     C+ Close SCursor
     C/END-EXEC
      *
     C                   IF        %Open(GPDWNLL0)                                         AR1092060
     C                   CLOSE     GPDWNLL0                                                AR1092060
     C                   ENDIF                                                             AR1092060
      *                                                                                    AR1092060
     C/COPY GOCPYSRC,GOUPD_DWNL                                                            AR1092060
      *                                                                                    AR1092060
     C                   ENDIF
     C                   ENDIF                                                             AR1092060
      *
     C                   EVAL      *INLR = *ON                                               CCB023A
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
     C                   ENDSR
      ****************************************************************
