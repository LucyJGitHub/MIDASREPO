     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Fix Zonal Customers')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDFIXCUST - Midas SD Fix Zonal Customers                     *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG12424 *CREATE   Date 16Nov06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG12424 - Error in enquiring customer numbers.              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Customer Details - Update Index
     FSDCUSTL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBG:SDCUSTD0)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Upper & Lowercase Character Constants
     D UPPER           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D LOWER           C                   'abcdefghijklmnopqrstuvwxyz'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C     *LOVAL        SETLL     SDCUSTL0
     C                   READ      SDCUSTL0
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      BBCUST = %TRIM(BBCUST)
 
     C                   EVAL      BBCUST = %XLATE(LOWER:UPPER:BBCUST)
 
     C                   EVAL      BBCSSN = %XLATE(LOWER:UPPER:BBCSSN)
 
     C                   UPDATE(E) SDCUSTD0
 
     C                   IF        %ERROR()
      ** Data will have to be amended manually at this point.
     C                   ENDIF
 
     C                   READ      SDCUSTL0
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   RETURN
 
     C                   ENDSR
