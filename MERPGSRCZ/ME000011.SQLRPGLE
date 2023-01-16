     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas ME Initialisation program for CSW209')           *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME000011 -  Midas ME Initialisation program for CSW209       *
      *                                                               *
      *  Function:  This program updates MEISOCPD File defaulting     *
      *             Support SWIFT MT205 field to N                    *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSW213             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW213 - SWIFT Changes 2013 (Recompile)                      *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7 - Database Error                                        *
      *    U8 - Database Error                                        *
      *    LR - Last record found                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas ME ISO Country Codes File
     F*MEISOCPD* UF   E             DISK    INFSR(*PSSR)                                    MD058081


      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      *
     D WRun            S              1A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C*****1****         SETLL     MEISOCD0                                                 MD058081
     C**********         READ      MEISOCD0                                                 MD058081
     C**********         DOW       NOT %EOF                                                 MD058081
     C**********         MOVE      'N'           M3M205                                     MD058081
     C**********         UPDATE    MEISOCD0                                                 MD058081
     C**********         READ      MEISOCD0                                                 MD058081
     C**********         ENDDO                                                              MD058081
     C/EXEC SQL                                                                             MD058081
     C+ update MEISOXTD set                                                                 MD058081
     C+   M3M205 = 'N'                                                                      MD058081
     C/END-EXEC                                                                             MD058081
      *
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2009
