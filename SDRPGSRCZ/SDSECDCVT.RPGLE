     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients details to scrn fmt')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSECDCVT - Security Customers Details Conversion:           *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of a Securities   *
      *             Clients Detail from file to screen format         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 240601             Date 02Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK024             Date 13Feb06               *
      *                 CSE070             Date 15Feb05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE042             Date 05Feb03               *
      *                 CSE041             Date 05Feb03               *
      *                 CSE039             Date 05Feb03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039  *CREATE    Date 30Sep99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  240601 - Apply fix 240346                                    *
      *  240346 - Customer number is not setup                        *
      *  CPK024 - Packaging of MPLUS 1.2.1. No need to rename QQACCD  *
      *           as it was already removed by 7453 from SEDECDPD.    *
      *  CSE070 - Repo Coupon Claims Report                           *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CSE042 - Auto Feed of Trades and Movements                   *
      *  CSE041 - DVP/RVP Processing                                  *
      *  CSE039 - Automatic Settlement of Trades                      *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CAP039 - Conversion of Midas inputs to modular API structure *
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SecsFilFmt    E DS                  EXTNAME(SDSECSPD)
      ** Securities Clients Details in File Format
 
     D SecDets       E DS                  EXTNAME(SDSECDPD)
     D*SecDetsACCD   E                     EXTFLD(QQACCD)                              CGL029 CPK024
      ** Securities Clients Details in Screen Format
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      INIT
 
      ** Set screen fields
 
     C                   EXSR      SCREEN
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
 
      * Customer Number                                                                       240346
     C                   Eval      DDCUSN = BFCUST                                            240346
      * Classification
     C                   Eval      DDCLAS = BFCLAS
 
      * Portfolio Currency
     C                   Eval      DDPCYC = BFPCYC
 
      * Settlement Currency
     C                   Eval      DDCYCD = BFCYCD
 
      * Account Code
     C                   Eval      DDACCD = BFACCD
 
      * Account Sequence
     C     BFACSN        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDACSN
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      BFACSN        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDACSN
     C                   ENDIF
 
      * Statement Frequency
     C                   Eval      DDSTFQ = BFSTFQ
 
      * Next Statement Date
     C     BFNSDT        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDSNSD
     C                   ELSE
     C                   Z-ADD     BFNSDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     *BLANKS       DDSNSD
     C                   MOVEL     ZDATE         DDSNSD
     C                   ENDIF
 
      * Statement Base Date
     C     BFSBDM        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDSBDM
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      BFSBDM        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDSBDM
     C                   ENDIF
 
      * Alternative Name and Address
     C                   Eval      DDADCD = BFADCD
 
      * Statutory Returns Code
     C                   Eval      DDSRCD = BFSRCD
 
      * Cedel Fungibility Indicator
     C                   Eval      DDCFIN = BFCFIN
 
      * Pledge Agreement
     C                   Eval      DDPLAG = BFPLAG
 
      * Tax Code
     C                   Eval      DDTXCD = BFTCD
 
      * Auto-Settle Indicator
     C                   Eval      DDASIN = BFASIN
 
      * Safe Custody Fees
     C                   Eval      DDSBJF = BFSBJF
 
      * Trade Charges Group
     C                   Eval      DDTDCG = BFTDCG
 
      * Custody Fees Group Code
     C                   Eval      DDCFGC = BFCFGC
 
      * Position Settlement Charge Group
     C                   Eval      DDPSCG = BFPSCG
 
      * Narrative
     C                   Eval      DDNARR = BFNARR
 
      * Depot Reference 1
     C**********         Eval      DDDRF1 = BFDRF1                                            CSE022
     C                   Eval      DDDRF1 = BFNDR1                                            CSE022
 
      * Depot Reference 2
     C**********         Eval      DDDRF2 = BFDRF2                                            CSE022
     C                   Eval      DDDRF2 = BFNDR2                                            CSE022
 
      * Depot Reference 3
     C**********         Eval      DDDRF3 = BFDRF3                                            CSE022
     C                   Eval      DDDRF3 = BFNDR3                                            CSE022
     C                   Eval      DDNDR3 = BFNDR3                                            CSE022
 
      * Depot Reference 4
     C**********         Eval      DDDRF4 = BFDRF4                                            CSE022
     C                   Eval      DDDRF4 = BFNDR4                                            CSE022
     C                   Eval      DDNDR4 = BFNDR4                                            CSE022
 
      * Depot Reference 5
     C**********         Eval      DDDRF5 = BFDRF5                                            CSE022
     C                   Eval      DDDRF5 = BFNDR5                                            CSE022
     C                   Eval      DDNDR5 = BFNDR5                                            CSE022
 
      * Depot Reference 6
     C**********         Eval      DDDRF6 = BFDRF6                                            CSE022
     C                   Eval      DDDRF6 = BFNDR6                                            CSE022
     C                   Eval      DDNDR6 = BFNDR6                                            CSE022
 
      * Depot Reference 7
     C**********         Eval      DDDRF7 = BFDRF7                                            CSE022
     C                   Eval      DDDRF7 = BFNDR7                                            CSE022
     C                   Eval      DDNDR7 = BFNDR7                                            CSE022
 
      * Depot Reference 8
     C**********         Eval      DDDRF8 = BFDRF8                                            CSE022
     C                   Eval      DDDRF8 = BFNDR8                                            CSE022
     C                   Eval      DDNDR8 = BFNDR8                                            CSE022
 
      * Depot Reference 9
     C**********         Eval      DDDRF9 = BFDRF9                                            CSE022
     C                   Eval      DDDRF9 = BFNDR9                                            CSE022
     C                   Eval      DDNDR9 = BFNDR9                                            CSE022
 
      * Depot Reference 10
     C**********         Eval      DDDRF0 = BFDRF0                                            CSE022
     C                   Eval      DDDRF0 = BFNDR0                                            CSE022
     C                   Eval      DDNDR0 = BFNDR0                                            CSE022
 
      * Participant/Non-Participant 1
     C                   Eval      DDPNP1 = BFPNP1
 
      * Participant/Non-Participant 2
     C                   Eval      DDPNP2 = BFPNP2
 
      * Participant/Non-Participant 3
     C                   Eval      DDPNP3 = BFPNP3
 
      * Participant/Non-Participant 4
     C                   Eval      DDPNP4 = BFPNP4
 
      * Participant/Non-Participant 5
     C                   Eval      DDPNP5 = BFPNP5
 
      * Participant/Non-Participant 6
     C                   Eval      DDPNP6 = BFPNP6
 
      * Participant/Non-Participant 7
     C                   Eval      DDPNP7 = BFPNP7
 
      * Participant/Non-Participant 8
     C                   Eval      DDPNP8 = BFPNP8
 
      * Participant/Non-Participant 9
     C                   Eval      DDPNP9 = BFPNP9
 
      * Participant/Non-Participant 10
     C                   Eval      DDPNP0 = BFPNP0
 
      * Settlement Advice Required                                                            CSE039
     C                   Eval      DDSARQ = BFSARQ                                            CSE039
                                                                                              CSE039
      * Contractual Settlement Customer Group                                                 CSE041
     C                   Eval      DDCSCG = BFCSCG                                            CSE041
                                                                                              CSE041
      * Contractual Settlement Required for DVP/RVP                                           CSE041
     C                   Eval      DDCSVP = BFCSVP                                            CSE041
                                                                                              CSE041
      * Error/Warning on Validation failure indicators                                        CSE042
     C                   Eval      DDEWVF = BFEWVF                                            CSE042
                                                                                              CSE042
      * Auto-Forward Unmatched Trade Messages                                                 CSE042
     C                   Eval      DDAFUM = BFAFUM                                            CSE042
                                                                                              CSE042
      * Auto-Forward Failed Trade Messages                                                    CSE042
     C                   Eval      DDAFFM = BFAFFM                                            CSE042
                                                                                              CSE042
      * Authorisation Required for STP Trades                                                 CSE042
     C                   Eval      DDARST = BFARST                                            CSE042
                                                                                              CSE042
      * Repo Claims Required                                                                  CSE070
     C                   Eval      DDRREQ = BFRREQ                                            CSE070
                                                                                              CSE070
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
 
      ** Blank outputs
 
     C                   MOVEL     *BLANK        SecDets
 
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * Output Parameters
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Securities Clients Details File Format
     C                   PARM                    SecsFilFmt
      *
 
      * Output Parameters
 
      * Securities Clients Details Screen Format
     C                   PARM                    SecDets
 
 
      ** Initialize program name
 
     C                   MOVEL     'SDSECDCVT'   DBPGM
 
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
