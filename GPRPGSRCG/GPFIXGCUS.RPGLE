     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Fix Global Customers')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPFIXGCUS - Midas GP Fix Global Customers                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG12424 *CREATE   Date 16Nov06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG12424 - Error in enquiring customer numbers.              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GP Global Customers - Update Index
     FGPCUSTL0  UF   E           K DISK    INFSR(*PSSR)
 
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
 
     C     *LOVAL        SETLL     GPCUSTL0
     C                   READ      GPCUSTL0
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      CUGCUS = %TRIM(CUGCUS)
 
     C                   EVAL      CUGCUS = %XLATE(LOWER:UPPER:CUGCUS)
 
     C                   EVAL      CUCSSN = %XLATE(LOWER:UPPER:CUCSSN)
 
     C                   UPDATE(E) GPCUSTD0
 
     C                   IF        %ERROR()
      ** Data will have to be amended manually at this point.
     C                   ENDIF
 
     C                   READ      GPCUSTL0
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
