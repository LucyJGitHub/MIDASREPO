     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Bulk Export of Base Rates')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI100005 - Midas TI Bulk Export of Base Rates                *
      *                                                               *
      *  Function: This program export of all of the existing         *
      *            historic base rates in the SDBSHSPD database.      *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD031150 *CREATE   Date 29Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD031150 - Changes to Export of Base Rates                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRExtrBSHS - Extract Historic Base Rate Data                  *
      * *INZSR  - Initialisation sub-routine                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas Historic Base Rates By Code + Date
     FSDBSHSL2  IF   E           K DISK    INFSR(*PSSR)

      ** Midas TI Base Rate Data File
     FTIBSHSPD  O    E           K DISK    INFSR(*PSSR)

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

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+

      ** Maximum number of analysis code
     D MaxNoAnalCd     C                   CONST(999)

      ** Analysis Code
     D #_ANAL          S              2    DIM(MaxNoAnalCd)

      ** Other field used
     D WRun            S              1A
     D @IX             S              3S 0 INZ(*ZERO)

      ** Work fields
     D W0CYCD          S                   LIKE(G0CYCD)
     D W0BSRC          S                   LIKE(G0BSRC)
     D W0HIDT          S                   LIKE(G0HIDT)
     D W0CBSR          S                   LIKE(G0CBSR)
     D W0COUNT         S              3S 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

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

      ** Extract Base Rate Driver File
     C                   EXSR      SRExtrBSHS

     C                   EVAL      *INLR  = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrBSHS  - Extract Historic Base Rate Data                *
      *                                                               *
      *****************************************************************

     C     SRExtrBSHS    BEGSR

     C                   MOVEL     *BLANKS       W0CYCD
     C                   Z-ADD     0             W0BSRC
     C                   Z-ADD     0             W0HIDT
     C                   Z-ADD     0             W0CBSR
     C                   Z-ADD     0             W0COUNT

      ** Read each row from Historic Base Rates file

     C     *LOVAL        SETLL     SDBSHSL2
     C                   READ      SDBSHSL2
     C                   DOW       NOT %EOF(SDBSHSL2)

     C                   IF        G0CYCD <> W0CYCD OR
     C                             G0BSRC <> W0BSRC OR
     C                             G0HIDT <> W0HIDT OR
     C                             G0CBSR <> W0CBSR

      ** Check if record is the 1st ccy/base rate combination

     C                   IF        G0CYCD <> W0CYCD OR
     C                             G0BSRC <> W0BSRC
     C                   Z-ADD     1             W0COUNT
     C                   ELSE
     C                   ADD       1             W0COUNT
     C                   ENDIF

      ** If this is the 1st ccy/base rate code combination, stored date
      ** is set to 2599-12-31, else set to previous date less 1.

     C                   MOVEL     G0CYCD        TICYCD
     C                   MOVEL     G0BSRC        TIBSRC
     C                   MOVEL     G0CBSR        TICBSR
     C                   IF        W0COUNT = 1
     C                   Z-ADD     25991231      TIVDTO
     C                   ELSE
     C     W0HIDT        SUB       1             TIVDTO
     C                   ENDIF

      ** Write data to historic base rate data file
     C                   IF        W0COUNT = 1 OR
     C                             G0CBSR <> W0CBSR
     C                   WRITE     TIBSHSD0
     C                   ENDIF

      ** Store previous data read to work fields
     C                   MOVEL     G0CYCD        W0CYCD
     C                   MOVEL     G0BSRC        W0BSRC
     C                   MOVEL     G0CBSR        W0CBSR
     C                   MOVEL     G0HIDT        W0HIDT
     C                   ENDIF

     C                   READ      SDBSHSL2
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
