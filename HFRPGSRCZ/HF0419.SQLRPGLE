     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas HF Update Midas User Info (CGP018)')
      *****************************************************************
      *                                                               *
      *  Midas - History and Audit Facility                           *
      *                                                               *
      *  HF0419   - Midas HF Update Midas User Info (CGP018)          *
      *                                                               *
      *  Called By: HFC0419 - Midas HF Update Midas User Info         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD024381B          Date 13Nov14               *
      *  Prev Amend No. MD024381A          Date 30Jun14               *
      *                 CGP018 *Create     Date 15Oct12               *
      *                 NNNNNN             Date DDMMMYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024381B - Reverse changes done by MD024381A.               *
      *  MD024381A - Correct SQL that replaces user field in the      *
      *              extract.                                         *
      *  CGP018 - Midas User Information                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *****************************************************************
      *  *INZSR     - Program initialisation                          *
      *  *PSSR      - Error handling subroutine                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      *****************************************************************

     D @RUN            S              1

      *****************************************************************

     C*E*EC*SQL
     C**UPDATE XX X SET X.JOUSER =
     C***(SELECT G.AHUSER FROM GPAUCHPD G WHERE
     C******G.AHCCID = X.JOCCID FETCH FIRST 1 ROWS ONLY)
     C***WHERE EXISTS (SELECT 1 FROM GPAUCHPD G
     C******WHERE G.AHCCID = X.JOCCID AND X.JOUSER = 'QUSER')
     C*E*D*EXEC

     C*E*EC*SQL
     C**UPDATE XX X SET X.JOUSER =
     C***(SELECT G.AHUSER FROM GPAUCHPD G WHERE
     C******G.AHCCID = X.JOCCID AND G.AHUSER <> 'QUSER'
     C******FETCH FIRST 1 ROWS ONLY)
     C***WHERE EXISTS (SELECT 1 FROM GPAUCHPD G
     C******WHERE G.AHCCID = X.JOCCID AND X.JOUSER = 'QUSER'
     C******AND G.AHUSER <> 'QUSER')
     C*E*D*EXEC                                                                  MD024381A MD024381B

     C/EXEC SQL
     C+ UPDATE XX X SET X.JOUSER =
     C+  (SELECT G.AHUSER FROM GPAUCHPD G WHERE
     C+     G.AHCCID = X.JOCCID FETCH FIRST 1 ROWS ONLY)
     C+  WHERE EXISTS (SELECT 1 FROM GPAUCHPD G
     C+     WHERE G.AHCCID = X.JOCCID AND X.JOUSER = 'QUSER')
     C/END-EXEC                                                                            MD024381B

     C                   RETURN

      *************************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR


     C                   ENDSR

      *************************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   DUMP
     C                   EVAL      @RUN = 'Y'
     C                   ENDIF
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
