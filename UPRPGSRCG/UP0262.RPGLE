     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*X*I ***OVRDBF*FILE(CPYDTA)*TOFILE(QADSPOBJ)**************************                       CPK025
/*XBI *  OVRDBF FILE(CPYDTA) TOFILE(UPOBJDTPD)                        *                       CPK025
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Update or check CPYDBLIB driving file')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP0262 - Upgrade or check CPYDBLIB driving file              *
      *                                                               *
      *  Called By: UPC0259                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025  *MOVED     Date 04Aug06               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CPK015  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK025 - MidasPlus 1.3 packaging.  Moved to global layer.    *
      *  CPK015 - 4.01 packaging.  Improvements to CPYDBLIB.          *
      *                                                               *
      *****************************************************************
      /EJECT
     FCPYDTA    UF   E             DISK
      *
      /SPACE 3
      *
     C     *ENTRY        PLIST
     C                   PARM                    object_name      10
     C                   PARM                    object_type       8
     C                   PARM                    mode              7
     C                   PARM                    return_code       1
 
      * Depending on mode perform appropriate sub-routine
     C     mode          IFEQ      '*CHECK'
     C                   EXSR      check
     C                   ELSE
     C     mode          IFEQ      '*UPDATE'
     C                   EXSR      update
     C                   ENDIF
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
 
      **********************************************************************
      *                                                                    *
      *  CHECK sub-routine                                                 *
      *                                                                    *
      **********************************************************************
     C     check         BEGSR
 
      * Read CPYDTA until record is found
     C                   READ      CPYDTA                                 20
     C     *IN20         DOUEQ     *ON
     C     *IN21         OREQ      *ON
 
     C     object_name   IFEQ      ODOBNM
     C     object_type   ANDEQ     ODOBTP
 
      * If this has already been copied then set return code to 'Y'.
     C     ODDDAT        IFEQ      'COPIED'
     C                   MOVEL     'Y'           return_code
     C                   ENDIF
     C                   SETON                                        21
     C                   ENDIF
 
     C                   READ      CPYDTA                                 20
 
     C                   ENDDO
 
     C     end_check     ENDSR
      **********************************************************************
      *                                                                    *
      *  update sub-routine                                                *
      *                                                                    *
      **********************************************************************
     C     update        BEGSR
 
      * Read CPYDTA until record is found
     C                   READ      CPYDTA                                 20
     C     *IN20         DOUEQ     *ON
     C     *IN21         OREQ      *ON
 
     C     object_name   IFEQ      ODOBNM
     C     object_type   ANDEQ     ODOBTP
 
      * Update unused field that this record has been copied.
     C                   MOVEL     'COPIED'      ODDDAT
     C                   UPDATE    QLIDOBJD
     C                   SETON                                        21
     C                   ENDIF
 
     C                   READ      CPYDTA                                 20
 
     C                   ENDDO
 
     C     end_update    ENDSR
      **********************************************************************
