     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Broker Code')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVBROKCDE - Validate Broker Code                            *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Broker Code field and confirms                    *
      *             whether it has a valid value.                     *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002   *CREATE   Date 14Oct97               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for access programs (long)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for Currencies file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for Broker codes file
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
 
      ** External data structure for SAR details                                              CER043
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER043
                                                                                              CER043
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D PSYSVL          C                   CONST('DefaultBroker')                             CER043
                                                                                              CER043
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Broker Code - received as a parameter
     D DDBKCD          S              4A
 
      ** Broker currency - output as a parameter
     D IKBKCY          S              3A
 
      ** Broker currency decimal places - output as a parameter
     D IKBCDP          S              1S 0
 
      ** Switchable feature                                                                   CER043
     D CER043          S              1A                                                      CER043
                                                                                              CER043
      ** Return Code                                                                          CER043
     D PRtcd           S              7A                                                      CER043
                                                                                              CER043
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
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C*
     C*  *------------------------*
     C*  * Validate Broker Code   *
     C*  *------------------------*
     C*
      *                                                                                       CER043
      **  Deafult broker code if switchable feature CER043 is on                              CER043
      *                                                                                       CER043
     C                   If        DDBKCD = *Blanks and CER043 = 'Y'                          CER043
     C                   MoveL     PSYSVL        PSVLK1                                       CER043
     C                   Call      'AOSVALR0'                                                 CER043
     C                   Parm      *Blanks       PRtcd                                        CER043
     C                   Parm                    PSVLK1           20                          CER043
     C                   Parm                    PSVL1           200                          CER043
     C                   Parm      *Blanks       PSVLK2           20                          CER043
     C                   Parm                    PSVL2           200                          CER043
     C                   Parm      *Blanks       PSVLK3           20                          CER043
     C                   Parm                    PSVL3           200                          CER043
     C                   Parm      *Blanks       PSVLK4           20                          CER043
     C                   Parm                    PSVL4           200                          CER043
     C                   Parm      *Blanks       PSVLK5           20                          CER043
     C                   Parm                    PSVL5           200                          CER043
     C                   Parm      *Blanks       PSVLK6           20                          CER043
     C                   Parm                    PSVL6           200                          CER043
     C                   Parm      *Blanks       PSVLK7           20                          CER043
     C                   Parm                    PSVL7           200                          CER043
     C                   Parm      *Blanks       PSVLK8           20                          CER043
     C                   Parm                    PSVL8           200                          CER043
     C                   Parm      *Blanks       PSVLK9           20                          CER043
     C                   Parm                    PSVL9           200                          CER043
     C                   Parm      *Blanks       PSVLK0           20                          CER043
     C                   Parm                    PSVL0           200                          CER043
      *                                                                                       CER043
     C                   If        PRtcd <> *Blanks and PSVL1 <> '*NRF'                       CER043
     C     *Lock         In        LDA                                                        CER043
     C                   Eval      DBKEY = PSVLK1                                             CER043
     C                   Eval      DBASE = 1                                                  CER043
     C                   Eval      DBFILE= 'SDSVALPD'                                         CER043
     C                   Eval      DBPGM = 'MMVBROKCDE'                                       CER043
     C                   Out       LDA                                                        CER043
     C                   Exsr      *PSSR                                                      CER043
     C                   Else                                                                 CER043
     C                   MoveL     PSVL1         DDBKCD                                       CER043
     C                   EndIf                                                                CER043
      *                                                                                       CER043
     C                   EndIf                                                                CER043
      *                                                                                       CER043
     C**  Error if broker code is blank
     C*
     C     DDBKCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0195'     Msgid1
     C                   END
     C*
     C**  If the Broker Code is not blank it must be TELX, PHON or
     C**  MAIL or exist on the Broker file.
     C*
     C     DDBKCD        IFNE      *BLANKS
     C     DDBKCD        ANDNE     'TELX'
     C     DDBKCD        ANDNE     'PHON'
     C     DDBKCD        ANDNE     'MAIL'
     C                   CALLB     'AOBROKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBKCD        @BQTX             4
     C     SDBROK        PARM      SDBROK        DSFDY
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0197'     Msgid1
     C                   ELSE
     C*
     C**  If a record has been found, find the no. of decimal places
     C**  for the broker currency.
      *  (database error handling done in access program)
     C                   MOVEL     A9BROK        DDBKCD
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      A9BRCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C**  Set up the output broker currency and the broker currency
     C**  decimal places
     C                   MOVEL     A9BRCY        IKBKCY
     C                   Z-ADD     A6NBDP        IKBCDP
     C                   END
     C                   END
 
      ** If no error was found, and the broker code is MAIL/PHON/TELX
      **  set up the broker currency and the broker currency decimal
      **  with blank/zero values.
      ** This is to cater for the case when one of these replaces an actual
      **  broker code, and hence to ensure that the currency / ccy d.p.
      **  do not retain previous values.
     C                   IF        ErrorFound <> 'Y'
     C                   IF           DDBKCD = 'MAIL'
     C                             OR DDBKCD = 'PHON'
     C                             OR DDBKCD = 'TELX'
     C                   CLEAR                   IKBKCY
     C                   CLEAR                   IKBCDP
     C                   ENDIF
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDBKCD
     C                   PARM                    IKBKCY
     C                   PARM                    IKBCDP
     C                   PARM                    SDBROK
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *                                                                                       CER043
      ** Check if CER043 is switched on                                                       CER043
                                                                                              CER043
     C                   Call      'AOSARDR0'                                                 CER043
     C                   Parm      *BLANKS       PRtcd                                        CER043
     C                   Parm      '*VERIFY'     POPTN             7                          CER043
     C                   Parm      'CER043'      PSARD             6                          CER043
     C     SCSARD        Parm      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   If        PRtcd = *BLANKS                                            CER043
     C                   Eval      CER043 = 'Y'                                               CER043
     C                   Else                                                                 CER043
     C                   Eval      CER043 = 'N'                                               CER043
                                                                                              CER043
     C                   If        PRtcd <> '*NRF'                                            CER043
     C     *Lock         IN        LDA                                                        CER043
     C                   Eval      DBKEY = 'CER043'                                           CER043
     C                   Eval      DBFILE = 'SCSARDPD'                                        CER043
     C                   Eval      DBASE = 002                                                CER043
     C                   OUT       LDA                                                        CER043
     C                   Exsr      *PSSR                                                      CER043
     C                   EndIf                                                                CER043
                                                                                              CER043
     C                   EndIf                                                                CER043
                                                                                              CER043
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
