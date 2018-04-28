     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Updates Invalid Data in FDDTSTPD File for AR796905')   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  SMU00612 - Utility to Update Invalid Data in FDDTSTPD File   *
      *                                                               *
      *  Function:  This program updates the Effective Date - EACC11  *
      *             field to zero, for all zero or blank (invalid)    *
      *             value in FDDTSTPD File                            *
      *                                                               *
      *  Called By: SMUC00612                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR796904 *CREATE   Date 20Dec12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR796904 - Utility to update the invalid value populated     *
      *             in FDDTSTPD Deal Type/SubType file.               *
      *             (Child: AR796905)                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    50         Update Mode                                     *
      *    60         No Details                                      *
      *    80         FDDTSTPD End of File                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *  WRTRPT - Write report details for SMU00612P1                 *
      *  *PSSR - Program Error Processing Subroutine                  *
      *                                                               *
      *****************************************************************
 
      ** Midas FD Deal Type/Sub Type
     FFDDTSTPD  UF   E           K DISK
     F                                     RENAME(FDDTSTPD:FDDTSTD0)
 
     FSMU00612P1O    E             PRINTER INFDS(SPOOL1)
      *****************************************************************
      /EJECT
      *****************************************************************
 
     D SPOOL1          DS
 
      ** DS For Access Programs, Short Data Structure
 
     D  OFFLN1               188    189B 0
     D  CURLN1               367    368B 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Bank Details and Rundate
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Short Data Structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for SAR Details
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Array containing Copyright statement
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Reference Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@             1
      *
      ** Check First if CSD039 is *OFF
      *
     C     CSD039        IFEQ      'N'
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   MOVE      'N'           WRTTRL
     C                   Z-ADD     0             TOTALU
     C                   MOVE      *OFF          *IN98
     C                   MOVE      *OFF          *IN60
      *
     C     MODE          IFEQ      'U'
     C     MODE          OREQ      'u'
     C                   MOVEL     '1'           *IN50
     C                   ENDIF
      *
     C     OFFLN1        SUB       1             THRLIN            2 0
     C     CURLN1        IFGE      THRLIN
     C                   WRITE     HEADER1
     C                   MOVE      'Y'           WRTTRL            1
     C                   ENDIF
      *
      ** Read Deal Type/SubType File
      *
     C                   READ      FDDTSTPD                               80
     C     *IN80         DOWEQ     '0'
      *
     C     MODE          IFEQ      'U'
     C     MODE          OREQ      'u'
     C                   MOVEL     '1'           *IN50
     C                   Z-ADD     0             EACC11
     C                   UPDATE    FDDTSTD0
     C                   ENDIF
     C                   ADD       1             TOTALU
     C                   EXSR      WRTRPT
     C                   READ      FDDTSTPD                               80
     C                   ENDDO
      *
     C     WRTTRL        IFEQ      'Y'
     C     TOTALU        IFEQ      0
     C                   MOVEL     '1'           *IN60
     C                   ENDIF
     C                   WRITE     TRAILER1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   SETON                                            LR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WRTRPT - Write FDDTSTPD record to the report detail line.     *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
     C     WRTRPT        BEGSR
      *
     C     OFFLN1        SUB       1             THRLIN            2 0
     C     CURLN1        IFGE      THRLIN
     C                   WRITE     HEADER1
     C                   MOVE      'Y'           WRTTRL            1
     C                   ENDIF
      *
     C                   MOVEL     DTPE11        R0DTPE
     C                   MOVEL     DLST11        R0DLST
     C                   MOVEL     NARR11        R0NARR
     C                   Z-ADD     LCD11         ZDAYNO
     C                   MOVE      ZADATE        R0LCD
      *
     C                   Z-ADD     EACC11        ZDAYNO
     C                   MOVEL     'D'           FORMAT            1
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    FORMAT
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C     ZADATE        IFNE      *BLANKS
     C                   MOVE      ZADATE        R0EACC
     C                   ELSE
     C                   MOVEL     '0'           R0EACC
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOSARDR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
      ** Check for switchable feature CSD039
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSD039'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE           10
     C                   MOVEL     'CSD039  '    DBKEY             3
     C                   MOVEL     '10'          DBASE             7
     C                   MOVEL     *BLANKS       @RUN              1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD039            1
     C                   ELSE
     C                   MOVE      'N'           CSD039
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR -  Program exception error subroutine.                  *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      *
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2012
