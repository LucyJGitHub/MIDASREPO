     H DEBUG
     H COPYRIGHT('(c) Finastra Ltd 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XX008004 - Midas SD Midas-Kondor I/f Customer Extract Purge  *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2023                 *
      *                                                               *
      *  Last Amend No. DRI008  *Create   Date 29Jun23                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DRI008 - Midas-Kondor Interface Customer Details             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *  U7+U8 - Data Base Error (job switch)                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRMAIN - Main Processing                                     *
      *  *PSSR  - Error Handling Subroutine                           *
      *  *INZSR - Initialisation                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                     *
      ** ¦ F-specs                              ¦                     *
      ** ¦ =======                              ¦                     *
      ** +--------------------------------------+                     *

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Aacces Programs, Long Data Structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WRUN            S              1
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D WCOUNTER        S              7  0
     D WRDNB           S              5  0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Main Processing

     C                   ExSR      SRMAIN

     C                   SetOn                                        LR
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAIN - Main Processing                                     *
      *                                                               *
      *****************************************************************

     C     SRMAIN        BegSR

      ** Process only items older than 30 days

     C                   Eval      WRDNB = BJRDNB - 30

     C/Exec SQL
     C+ Set Option Commit = *CHG
     C/End-Exec

     C                   Eval      WCOUNTER = 0

     C/Exec SQL
     C+ Select COUNT(*) Into :WCOUNTER From XXMQCUTD
     C+ Where XRDNB < :WRDNB
     C/End-Exec

     C                   If        SQLCOD <> *Zero
     C     *LOCK         In        LDA
     C                   Eval      DBFILE = 'XXMQCUTD'
     C                   Eval      DBKEY  = %CHAR(WRDNB)
     C                   Eval      DBASE  = 5
     C                   Out       LDA
     C                   ExSR      *PSSR
     C                   EndIf

     C                   If        WCOUNTER > *Zero
     C/Exec SQL
     C+ Delete From XXMQCUTD
     C+ Where XRDNB < :WRDNB
     C/End-Exec

     C                   If        SQLCOD <> *Zero
     C     *LOCK         In        LDA
     C                   Eval      DBFILE = 'XXMQCUTD'
     C                   Eval      DBKEY  = %CHAR(WRDNB)
     C                   Eval      DBASE  = 4
     C                   Out       LDA
     C                   ExSR      *PSSR
     C                   EndIf
     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************

     C     *INZSR        BegSR

      ** Access Bank details

     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*FIRST '     POPTN
     C     SDBANK        Parm      SDBANK        DSSDY

     C                   If        PRTCD <> *BLANKS
     C     *LOCK         In        LDA
     C                   Eval      DBFILE = 'SDBANKPD'
     C                   Eval      DBKEY  = '*FIRST'
     C                   Eval      DBASE  = 1
     C                   Out       LDA
     C                   ExSR      *PSSR
     C                   EndIf

     C                   EndSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Error handling subroutine                            *
      *          Executes whenever field or program exception         *
      *          error occurs                                         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BegSR

     C                   If        WRUN  = *BLANK

     C                   Eval      WRUN = 'Y'
     C                   Eval      DBPGM = 'XX008004'
     C                   Dump
     C
     C                   EndIf

     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
     C                   Return

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra Ltd 2023
