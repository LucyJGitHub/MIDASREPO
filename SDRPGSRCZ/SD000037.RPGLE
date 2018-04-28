     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Set TI Customer Flag')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000037 - Set TI Customer Flag                              *
      *                                                               *
      *  Function:  Updates BBTICS to 'Y' of TI Accounts with         *
      *             BBTICS='N'.                                       *
      *                                                               *
      *  Called By: SDC000037 - Data Patch Program for BUG5168        *
      *                                                               *
      *  (C) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG5168  *CREATE   Date 15Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG5168 - Set TI Customer Flag (BBTICS) in PF/SDCUSTPD if    *
      *            customer is also a TI Customer.                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Update mode                                     *
      *    03         Read SDTICSPD                                   *
      *    04         Read SDCUSTL0                                   *
      *    06         Read SDFCTLL0                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDTICSPD  IF   E           K DISK
     FSDCUSTL0  UF   E           K DISK
     FSDFCTLL0  UF   E           K DISK
     FSD000037P1O    E             PRINTER
     FSD000037AUO    E             PRINTER
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Prpgrams, Short Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D MODE            S              1
     D FNAME           S             10
     D COUNT           S              5  0 INZ(0)
     D RECCNT          S              5  0 INZ(0)
     D LNCNT           S              2  0 INZ(10)
     D ZAPGMQ          S             10    INZ(' ')
     D ZAPGRL          S              5    INZ(' ')
     D ZAMSID          S              7    INZ('Y2U0009')
     D ZAMSGF          S             10    INZ('GBY2USRMSG')
     D ZAMSDA          S            132    INZ(' ')
     D ZAMSTP          S              7    INZ(' ')
     D PRTCD           S              7
     D POPTN           S              7
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    MODE
 
     C     KEY           KLIST
     C                   KFLD                    FNAME
 
     C                   IF        MODE = 'U' OR MODE = 'u'
     C                   EVAL      *IN01 = *ON
     C                   ENDIF
 
     C                   EVAL      *IN05 = *OFF
     C                   EVAL      FNAME = 'SDCUSTPD'
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Print header
 
     C                   WRITE     HEADP1
     C                   WRITE     DETLP1
     C                   WRITE     HEADAU
 
     C                   READ      SDTICSPD                               03
 
     C                   DOW       *IN03 = *OFF
 
     C                   EVAL      RECCNT = RECCNT + 1
     C     TCCUST        CHAIN     SDCUSTL0                           04
 
     C                   IF        *IN04 = *OFF  AND BBTICS = 'N'
 
     C                   IF        LNCNT > 58
     C                   WRITE     HEADP1
     C                   WRITE     DETLP1
     C                   EVAL      LNCNT = 10
     C                   ENDIF
 
     C                   WRITE     DETLP1A
     C                   EVAL      *IN42 = *ON
 
     C                   EVAL      LNCNT = LNCNT + 1
     C                   EVAL      COUNT = COUNT + 1
     C                   EVAL      *IN05 = *ON
 
     C                   IF        *IN01 = *ON
     C                   EVAL      BBTICS = 'Y'
     C                   EXCEPT    UPDTIC
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      SDTICSPD                               03
     C                   ENDDO
 
      ** Totals
 
     C                   IF        LNCNT > 56
     C                   WRITE     HEADP1
     C                   EVAL      LNCNT = 9
     C                   ENDIF
 
     C                   IF        *IN01 = *ON
     C     KEY           CHAIN     SDFCTLL0                           06
 
      ** Record not found
 
     C                   IF        *IN06 = *ON
 
      ** Send message '*Record no longer on file'
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
 
     C                   ELSE
 
     C                   EVAL      AHNOAM = AHNOAM + COUNT
     C                   UPDATE    @AHREAU
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        LNCNT <= 58
     C                   WRITE     ENDP1
     C                   WRITE     DETLAU
     C                   ELSE
     C                   WRITE     HEADP1
     C                   WRITE     ENDP1
     C                   WRITE     DETLAU
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
      ********************************************************************
     O@BBREBG   E            UPDTIC
     O                       BBTICS
