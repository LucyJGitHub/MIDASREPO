     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update reporting codes MCBLRPPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM001804 - Update Reporting codes on MCBLRPPD                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CUP038             Date 13Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 243654             Date 18Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025             Date 17Aug06               *
      *                 CGL034  *CREATE    Date 15Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP038 - Reporting codes should not be treated as account    *
      *           codes.  Just pad with leading zeros if not '*'.     *
      *           Reverse CPK025.                                     *
      *  243654 - Account Code by BS/PL Code Enquiry screen error.    *
      *           Apply CPK025 originally done at MidasPlus 1.3       *
      *  CPK025 - MidasPlus 1.3 packaging.  Get new account code      *
      *           value from SMAC10PD rather than just padding.       *
      *           See also SC 243654.                                 *
      *  CGL034 - Convert reporting codes separately from account     *
      *           codes.                                              *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FMCBLRPPD  UF   E             DISK    INFSR(*PSSR)
      ** Accounts by reporting codes file
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Program Parameters
     D PRtCd           S              7A
      *
      ** Working Variables
     D WRK4            S              4A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Read MCBLRPPD file.
      *
     C     *IN01         DOWEQ     *OFF
      *
     C                   READ      MCBLRPPD                               01
      *
     C     *IN01         IFEQ      *OFF
      *
      *  Move 4-digit code into work field WRK4.
     C                   MOVEL     GLRSCD        WRK4
     C                   MOVE      *BLANKS       GLRSCD
      *
      *  If reporting code is '****',
     C     WRK4          IFEQ      '****'
      *
      *  Move asterisks into the first 6 positions.
     C                   MOVEL     '******'      GLRSCD
      *
      *  If reporting code is not asterisks,
     C                   ELSE
      *
      ** Move*leading*zeros*into*the*first*6*positions.*                                      CPK025
     C**********         MOVEL     '000000'      GLRSCD                                       CPK025
     C**********         CALL      'SM00AC10'                                          CPK025 CUP038
     C**********         PARM                    WRK4                                  CPK025 CUP038
     C**********         PARM                    GLRSCD                                CPK025 CUP038
      *
      *  move leading zeros into the first 6 positions.                                       CUP038
     C                   MOVEL     '000000'      GLRSCD                                       CUP038
     C                   ENDIF
      *
      ** Move*the*reporting*code*into*the*right*4*postions.*                                  CPK025
     C**********         MOVE      WRK4          GLRSCD                                       CPK025
      * Move the reporting code into the right 4 postions.                                    CUP038
     C                   MOVE      WRK4          GLRSCD                                       CUP038
      *
      *  Update the record.
      *
     C                   UPDATE    MCBLRPF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtCd
      *
     C                   EVAL      PRtCd = '       '
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      PRtCd = '*ERROR '
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
