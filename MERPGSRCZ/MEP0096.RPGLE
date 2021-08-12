     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME STP Repair Function')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management                                   *
      *                                                               *
      *  MEP0096   - STP Check Function. Checks if the message        *
      *              currency is one of the main dealing currencies   *
      *                                                               *
      *  Function:  This check function checks if the currency of     *
      *             message is one of the main dealing currencies.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 10Nov11               *
      *                 HVB016  *CREATE    Date 10Nov11               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP Enhancements to Midas Plus level.     *
      *  HVB016 - STP Check if currency is one of the main ccy        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *  Message parts file for currency of payment
     FMEINMPL1  IF   E           K DISK
      *
      *  Message parts file for currency of payment
     FFTMCCYP0  IF   E           K DISK
      *
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *  97 : General Chain Indicator                                 *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

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

      /COPY MECPYSRC,ME1100_ILE
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *?External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      *? Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D PCRIT         E DS                  EXTNAME(MEGNCRPD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *?Entry parameters

     D  WUFDDT                 1    256
     D  WUMTAG                 1      5
     D  WUFDIN                 6      6
     D  WUTGCK                 6    256
     D  WUTGVL                 7    256
     D  WUACCO                 7     30
     D  WUCNUM                 7     12  0
     D  WUCNUA                 7     12
     D  WUCURR                13     15
     D  WUACCD                16     25  0
     D  WUACCA                16     25
     D  WUACSQ                26     27  0
     D  WUACSA                26     27
     D  WUBRCA                28     30
     D  WUORIG                31    256
     D  LINE1                 31     65
     D  LINE2                 66    100
     D  LINE3                101    135
     D  LINE4                136    170
     D  LINE5                171    205
     D  SLASH                 31     31
     D  WUO                   31    256
      *
      *?Work Variables

     D DIGITS          C                   CONST('0123456789')
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   MOVE      P#PTTN        U#ACT             5
      *
     C                   SELECT
      * * Check if the message currency is one of the Main currencies.
     C     U#ACT         WHENEQ    '*MCCY'
     C                   EXSR      SRMainCCY
      *
     C                   EndSL
      *  Exit program
     C                   SETON                                        LR
      *
     C                   Return
      **
      *****************************************************************
      *  SrMainCCY - Check if the message currency is one of the      *
      *              designated Main currencies                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRMainCCY     BEGSR

     C                   Z-ADD     PHMSGR        KPMSGR
     C                   Z-ADD     PHPART        KPKPRT
      * get currency of the message
     C     KINMP         CHAIN     @INMPL1                            91
      *
      * When message not found - skip the rest of processing
      *
     C     *IN91         IfEq      *OFF
      *
     C     MPCYCD        Chain     FTMCCYD0                           92
     C     *IN92         IfEq      *OFF
     C     FTTDAY        AndEq     'Y'
      *  Record found and it is one of the main currencies. Main currencies
      *  will have the flag FTTDAY set to Y. It means that the authorised
      *  payment can be made if value date is today.
     C                   MoveL     'T'           P#RETN

     C                   EndIf

     C                   EndIf

     C                   Endsr
      /EJECT
      *****************************************************************
      *  INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *LIKE         DEFINE    WUTGCK        P@IN
      *
      *?Entry parameters:
     C     *Entry        Plist
      *
      *  Return Code
     C                   Parm                    P#RETN            7
      *
     C     WUFDDT        PARM                    P@IN
      *
     C                   PARM                    P#PTTN           32
     C                   PARM                    GDOPER            2
      *  General Details
     C                   Parm                    PHEAD
      *  Message Details
     C                   Parm                    PDATA
      *  Message Details
     C                   PARM                    PDAT2
     C                   PARM                    PCRIT

      *?Initialise program name
     C                   Eval      DBPGM = PsProcPgm

      * If true put T
     C                   MOVEL     'F'           P#RETN

      *  Key list to access MEINMPPD
     C     KINMP         KLIST
     C                   KFLD                    KPMSGR            8 0
     C                   KFLD                    KPKPRT            3 0
      *
     C                   Endsr
      *****************************************************************
      ********************************************************************
      /EJECT
      *****************************************************************
      *  Program, module and procedure names for database error processing.
      *  =================================================================
      *  The following /COPY sets these values, and also defines LDA as
      *  an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
