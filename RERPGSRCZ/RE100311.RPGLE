     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Header Field Conv')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100311 - Cash Management Header Field Conversion           *
      *                                                               *
      *  Function:  This program converts certain fields in the       *
      *             'front end' cash management header record         *
      *             from file to screen format.                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
 
 
      /SPACE 5
 
 
      * Edit date effective from
 
     C                   Z-ADD     I_DEFR        ZDAYNO
     C                   EXSR      ZDATE2
     C     I_DATFMT      IFEQ      'N'
     C                   MOVEL     ZDATEN        DDDEFR
     C                   ELSE
     C                   MOVEL     ZADATE        DDDEFR
     C                   ENDIF
 
      * Edit review date
 
     C                   Z-ADD     I_RVDT        ZDAYNO
     C                   EXSR      ZDATE2
     C     I_DATFMT      IFEQ      'N'
     C                   MOVEL     ZDATEN        DDRVDT
     C                   ELSE
     C                   MOVEL     ZADATE        DDRVDT
     C                   ENDIF
 
      * Edit last change date
 
     C                   Z-ADD     I_LCDT        ZDAYNO
     C                   EXSR      ZDATE2
     C     I_DATFMT      IFEQ      'N'
     C                   MOVEL     ZDATEN        DDLCDT
     C                   ELSE
     C                   MOVEL     ZADATE        DDLCDT
     C                   ENDIF
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Convert a day number into a date
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
 
      * INPUTS
 
      * Date format
     C                   PARM                    I_DATFMT          1
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM                    I_DEFR            5 0
     C                   PARM                    I_RVDT            5 0
     C                   PARM                    I_LCDT            5 0
 
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM                    DDDEFR            7
     C                   PARM                    DDRVDT            7
     C                   PARM                    DDLCDT            7
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
