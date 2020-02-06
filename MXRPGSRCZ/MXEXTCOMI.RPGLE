     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Extract a composite message identifier')      *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXTCOMI - Extract a Composite Message ID                   *
      *                                                               *
      *  Function:  This module extracts composite messages           *
      *             for export to Meridian                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CTI006             Date 31Mar14               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241970             Data 05Sep06               *
      *                 CMX012             Data 16Jun06               *
      *                 CSE040             Data 04Feb03               *
      *                 CGL018             Date 02Oct02               *         CGL018
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025             Data 28May02               *
      *                 204629             Data 16Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE029             Data 17Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189208             Data 25Jan01               *
      *                 CMX004             Date 30Nov00               *
      *                 CMX003             Date 05Nov00               *
      *                 CMX002             Data 26Sep00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268 (Recompile)                                *
      *  241970 - Recompiled due to change in MXACSPRME.              *
      *  CMX012 - Midas Exports Dummy Program                         *
      *  CSE040 - Securities Statement Production                     *
      *  CGL018 - Risk Weighted assets balance formats added          *         CGL018
      *  CSW025 - Midas Message Manager                               *
      *           - New MT566 messages for ISO15022                   *
      *  204629 - Recompile due to fix 200292                         *
      *  CSE029 - ISO15022 Message Generation (recompile)             *
      *  189208 - Consolidation of Loans & participations into 1 fmt  *
      *  CMX004 - Meridian Export Enhancements - Phase 3              *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX002 - Meridian Export Enhancements - Phase 1              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXCOMDPD  UF   E           K DISK    INFSR(*PSSR)
      * Composite Message Details
     FMXCOMFL1  IF   E           K DISK    INFSR(*PSSR)
      * Composite Message Formats
     FMXEXFDL3  IF   E           K DISK    INFSR(*PSSR)
      * Formats
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
     D   InData        S           4000A
     D   InFmt         S             10A
 
     D   OutPos        S              4S 0
     D   OutData       S           4000A
 
     D                 DS
     D   ScData        S           4000
 
 
      * FORMAT
     D #_FMT           S             10    DIM(20)
      * COM FORMAT
     D #_COMF          S            150    DIM(20)
      * ACCESS MODULE
     D #_ACSM          S             10    DIM(20)
 
 
      * DATA EXTRACTED
     D #_DATA01        S           4000
     D #_DATA02        S           4000
     D #_DATA03        S           4000
     D #_DATA04        S           4000
     D #_DATA05        S           4000
     D #_DATA06        S           4000
     D #_DATA07        S           4000
     D #_DATA08        S           4000
     D #_DATA09        S           4000
     D #_DATA10        S           4000
     D #_DATA11        S           4000
     D #_DATA12        S           4000
     D #_DATA13        S           4000
     D #_DATA14        S           4000
     D #_DATA15        S           4000
     D #_DATA16        S           4000
     D #_DATA17        S           4000
     D #_DATA18        S           4000
     D #_DATA19        S           4000
     D #_DATA20        S           4000
 
 
      * Composite Message Details
     D MXCOMD        E DS                  EXTNAME(MXCOMDPD)
      * Composite Message Formats
     D MXCOMF        E DS                  EXTNAME(MXCOMFPD)
 
      ** SAR descriptions                                                                     CMX012
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CMX012
     D                                     PREFIX(S1)                                         CMX012
      ** DS for Access Object Programs                                                        CMX012
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CMX012
 
      * M Q   S E R I E S   D A T A
     D/COPY MXCPYSRC,MXMQDAD
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Mode
      * Composite ID
      * Extract Type
      * Journal Seq. (if Dripfeed)
     C                   PARM                    I#MODE            1
     C                   PARM                    I#COMI            8
     C                   PARM                    I#EXTT            1
     C                   PARM                    I#REFS           10
      * DRIVER Incoming Data
     C                   PARM                    DRV_InData     4000
      * OUTPUT
      * Reference ID
      * Select For Export
     C                   PARM                    O#ReferID        40
     C                   PARM                    O#Sel_EXP         1
 
      * If a new composite message ID or extract type, load formats
 
     C     I#COMI        IFNE      W#COMI
     C     I#EXTT        ORNE      W#EXTT
     C                   EXSR      LOAD_FMT
     C                   MOVEL     I#COMI        W#COMI            8
     C                   MOVEL     I#EXTT        W#EXTT            1
     C                   ENDIF
 
      * Read through Composite Message Formats
 
     C                   Z-ADD     1             @I                2 0
     C     @I            DOUGT     20
 
      * Process the format
 
     C     #_FMT(@I)     IFNE      *BLANK                                       *
     C                   MOVEL     #_COMF(@I)    MXCOMF
     C                   MOVEL     #_ACSM(@I)    EXACSM
     C                   EXSR      PROC_FMT
     C                   ENDIF
 
     C                   ADD       1             @I
 
     C                   ENDDO
 
      * Write Performance Log data
 
     C     CDLOGP        IFEQ      'Y'
     C     I#MODE        ANDNE     'D'
     C                   MOVEL     'X'           I#FUNC
     C                   EXSR      WRT_PLOG
     C                   ENDIF
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * Load Formats
      ********************************************************************
     C     LOAD_FMT      BEGSR
 
      * Get Composite Message Details
 
     C     MXCOMDK       CHAIN     MXCOMDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'MISSING COMPOSITE:'
     C                             + I#COMI + I#EXTT
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Clear list of formats
 
     C                   MOVEL     *BLANK        #_FMT
     C                   MOVEL     *BLANK        #_COMF
     C                   MOVEL     *BLANK        #_ACSM
 
      * Get Composite Message Formats
      * and access modules
 
     C     MXCOMFK       SETLL     MXCOMFP0                                     *
     C     MXCOMFK       READE     MXCOMFP0                               99    *
     C     *IN99         DOWEQ     '0'
 
      * If mode is 'DRIP-FEED'
      * Put all data to the 'LONG' file
 
     C     I#MODE        IFEQ      'D'
     C                   MOVEL     'L'           CFFILT
     C                   MOVEL     'N'           CFOPTF
     C                   ENDIF
 
     C     CFFMT         CHAIN     MXEXFDP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'MISSING FORMAT: '
     C                             + CFFMT
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     CFPRSQ        @I                2 0
     C                   MOVEL     CFFMT         #_FMT(@I)
     C                   MOVEL     MXCOMF        #_COMF(@I)
     C                   MOVEL     EXACSM        #_ACSM(@I)
 
     C     MXCOMFK       READE     MXCOMFP0                               99    *
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Process the format
      ********************************************************************
     C     PROC_FMT      BEGSR
 
     C                   EXSR      DERIV_LFD
 
     C     ACS_RTCD      DOUEQ     '*EODATA'
     C     CFMULT        OREQ      'N'
 
     C                   SELECT
 
     C     EXACSM        WHENEQ    'MXACSACCTD'
     C                   CALLB     'MXACSACCTD'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSACCTI'
     C                   CALLB     'MXACSACCTI'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSACCTR'
     C                   CALLB     'MXACSACCTR'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSACOD '
     C                   CALLB     'MXACSACOD '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSBCYE '
     C                   CALLB     'MXACSBCYE '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSBKPB'                                  CMX003
     C                   CALLB     'MXACSBKPB'                                  CMX003
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX003
                                                                                CMX003
     C     EXACSM        WHENEQ    'MXACSBKPH'                                  CMX003
     C                   CALLB     'MXACSBKPH'                                  CMX003
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX003
                                                                                CMX003
     C     EXACSM        WHENEQ    'MXACSBLDL '
     C                   CALLB     'MXACSBLDL '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSBLGL '
     C                   CALLB     'MXACSBLGL '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSBLLEL'
     C                   CALLB     'MXACSBLLEL'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCFCO '
     C                   CALLB     'MXACSCFCO '
     C/COPY MXCPYSRC,MXACSPRME
                                                                                CSE029
     C     EXACSM        WHENEQ    'MXACSCGT'                                   CSE029
     C                   CALLB     'MXACSCGT'                                   CSE029
     C/COPY MXCPYSRC,MXACSPRME                                                  CSE029
 
     C     EXACSM        WHENEQ    'MXACSCIRS '
     C                   CALLB     'MXACSCIRS '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCLGU1'
     C                   CALLB     'MXACSCLGU1'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCLGU2'
     C                   CALLB     'MXACSCLGU2'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCLLN1'
     C                   CALLB     'MXACSCLLN1'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCLLN2'
     C                   CALLB     'MXACSCLLN2'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCLPS1'
     C                   CALLB     'MXACSCLPS1'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCLPS2'
     C                   CALLB     'MXACSCLPS2'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCLZZ1'                                 189208
     C                   CALLB     'MXACSCLZZ1'                                 189208
     C/COPY MXCPYSRC,MXACSPRME                                                  189208
                                                                                189208
     C     EXACSM        WHENEQ    'MXACSCLZZ2'                                 189208
     C                   CALLB     'MXACSCLZZ2'                                 189208
     C/COPY MXCPYSRC,MXACSPRME                                                  189208
                                                                                189208
     C     EXACSM        WHENEQ    'MXACSCPSS '                                 CMX003
     C                   CALLB     'MXACSCPSS '                                 CMX003
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX003
                                                                                CMX003
     C     EXACSM        WHENEQ    'MXACSCTRY '
     C                   CALLB     'MXACSCTRY '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCURR '
     C                   CALLB     'MXACSCURR '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCUST '
     C                   CALLB     'MXACSCUST '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCUST2'                                 CSE029
     C                   CALLB     'MXACSCUST2'                                 CSE029
     C/COPY MXCPYSRC,MXACSPRME                                                  CSE029
                                                                                CSE029
     C     EXACSM        WHENEQ    'MXACSCQCOD'
     C                   CALLB     'MXACSCQCOD'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCQPAC'
     C                   CALLB     'MXACSCQPAC'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSCUSX '
     C                   CALLB     'MXACSCUSX '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSDEDL '
     C                   CALLB     'MXACSDEDL '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSDEGL '
     C                   CALLB     'MXACSDEGL '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSDELEF'
     C                   CALLB     'MXACSDELEF'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSDELEL'
     C                   CALLB     'MXACSDELEL'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSDESEB'                                 CMX003
     C                   CALLB     'MXACSDESEB'                                 CMX003
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX003
                                                                                CMX003
     C     EXACSM        WHENEQ    'MXACSDESET'
     C                   CALLB     'MXACSDESET'
     C/COPY MXCPYSRC,MXACSPRME
                                                                                CSE029
     C     EXACSM        WHENEQ    'MXACSDPTM '                                 CSE029
     C                   CALLB     'MXACSDPTM '                                 CSE029
     C/COPY MXCPYSRC,MXACSPRME                                                  CSE029
                                                                                CSE029
     C     EXACSM        WHENEQ    'MXACSDPTM1'                                 CSE029
     C                   CALLB     'MXACSDPTM1'                                 CSE029
     C/COPY MXCPYSRC,MXACSPRME                                                  CSE029
                                                                                CSE029
     C     EXACSM        WHENEQ    'MXACSDPTM2'                                 CSE029
     C                   CALLB     'MXACSDPTM2'                                 CSE029
     C/COPY MXCPYSRC,MXACSPRME                                                  CSE029
 
     C     EXACSM        WHENEQ    'MXACSEXAT '
     C                   CALLB     'MXACSEXAT '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSFCLT1'
     C                   CALLB     'MXACSFCLT1'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSFCLT2'
     C                   CALLB     'MXACSFCLT2'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSDLRWA'                                 CGL018
     C                   CALLB     'MXACSDLRWA'                                 CGL018
     C/COPY MXCPYSRC,MXACSPRME                                                  CGL018
 
     C     EXACSM        WHENEQ    'MXACSFEEF '
     C                   CALLB     'MXACSFEEF '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSFEEL '
     C                   CALLB     'MXACSFEEL '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSFRAS '
     C                   CALLB     'MXACSFRAS '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSFTCC '                                 CMX002
     C                   CALLB     'MXACSFTCC '                                 CMX002
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX002
                                                                                CMX002
     C     EXACSM        WHENEQ    'MXACSFTFX '                                 CMX002
     C                   CALLB     'MXACSFTFX '                                 CMX002
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX002
                                                                                CMX002
     C     EXACSM        WHENEQ    'MXACSFTPI '
     C                   CALLB     'MXACSFTPI '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSFXDL '
     C                   CALLB     'MXACSFXDL '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSFXDLX'
     C                   CALLB     'MXACSFXDLX'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSFXFR '                                 CMX004
     C                   CALLB     'MXACSFXFR '                                 CMX004
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX004
                                                                                CMX004
     C     EXACSM        WHENEQ    'MXACSLDNI '
     C                   CALLB     'MXACSLDNI '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSLDNI2'                                 CSE029
     C                   CALLB     'MXACSLDNI2'                                 CSE029
     C/COPY MXCPYSRC,MXACSPRME                                                  CSE029
                                                                                CSE029
     C     EXACSM        WHENEQ    'MXACSLDNIX'
     C                   CALLB     'MXACSLDNIX'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSMEDL '
     C                   CALLB     'MXACSMEDL '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSMEGL '
     C                   CALLB     'MXACSMEGL '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSMELEF'
     C                   CALLB     'MXACSMELEF'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSMELEL'
     C                   CALLB     'MXACSMELEL'
     C/COPY MXCPYSRC,MXACSPRME
                                                                                CGL018
     C     EXACSM        WHENEQ    'MXACSGLRWA'                                 CGL018
     C                   CALLB     'MXACSGLRWA'                                 CGL018
     C/COPY MXCPYSRC,MXACSPRME                                                  CGL018
 
     C     EXACSM        WHENEQ    'MXACSMESEB'                                 CMX003
     C                   CALLB     'MXACSMESEB'                                 CMX003
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX003
                                                                                CMX003
     C     EXACSM        WHENEQ    'MXACSMESET'
     C                   CALLB     'MXACSMESET'
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSMKC'                                   CSE029
     C                   CALLB     'MXACSMKC'                                   CSE029
     C/COPY MXCPYSRC,MXACSPRME                                                  CSE029
                                                                                CSE029
     C     EXACSM        WHENEQ    'MXACSMULT '
     C                   CALLB     'MXACSMULT '
     C/COPY MXCPYSRC,MXACSPRME
                                                                                CGL018
     C     EXACSM        WHENEQ    'MXACSLERWA'                                 CGL018
     C                   CALLB     'MXACSLERWA'                                 CGL018
     C/COPY MXCPYSRC,MXACSPRME                                                  CGL018
 
     C     EXACSM        WHENEQ    'MXACSNASP '
     C                   CALLB     'MXACSNASP '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSNASS '
     C                   CALLB     'MXACSNASS '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSREGN '
     C                   CALLB     'MXACSREGN '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSREHS '
     C                   CALLB     'MXACSREHS '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSRETC '                                 CMX002
     C                   CALLB     'MXACSRETC '                                 CMX002
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX002
                                                                                CMX002
     C     EXACSM        WHENEQ    'MXACSRETR '                                 CMX002
     C                   CALLB     'MXACSRETR '                                 CMX002
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX002
                                                                                CMX002
     C     EXACSM        WHENEQ    'MXACSRETT '                                 CMX003
     C                   CALLB     'MXACSRETT '                                 CMX003
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX003
                                                                                CMX003
     C     EXACSM        WHENEQ    'MXACSRINT '                                 CMX002
     C                   CALLB     'MXACSRINT '                                 CMX002
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX002
                                                                                CMX002
     C     EXACSM        WHENEQ    'MXACSRISL '                                 CHASE
     C                   CALLB     'MXACSRISL '                                 CHASE
     C/COPY MXCPYSRC,MXACSPRME                                                  CHASE
                                                                                CHASE
     C     EXACSM        WHENEQ    'MXACSGLSL '                                 CHASE
     C                   CALLB     'MXACSGLSL '                                 CHASE
     C/COPY MXCPYSRC,MXACSPRME                                                  CHASE
                                                                                CHASE
     C     EXACSM        WHENEQ    'MXACSSECS '
     C                   CALLB     'MXACSSECS '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSSECT '                                 CMX003
     C                   CALLB     'MXACSSECT '                                 CMX003
     C/COPY MXCPYSRC,MXACSPRME                                                  CMX003
                                                                                CMX003
     C     EXACSM        WHENEQ    'MXACSSERWA'                                 CGL018
     C                   CALLB     'MXACSSERWA'                                 CGL018
     C/COPY MXCPYSRC,MXACSPRME                                                  CGL018
                                                                                CGL018
     C     EXACSM        WHENEQ    'MXACSSIRS '
     C                   CALLB     'MXACSSIRS '
     C/COPY MXCPYSRC,MXACSPRME
 
     C     EXACSM        WHENEQ    'MXACSSTRD '
     C                   CALLB     'MXACSSTRD '
     C/COPY MXCPYSRC,MXACSPRME
     C     EXACSM        WHENEQ    'MXACSSTR1'                                  CSE029
     C                   CALLB     'MXACSSTR1'                                  CSE029
     C/COPY MXCPYSRC,MXACSPRME                                                  CSE029
                                                                                CSE029
     C     EXACSM        WHENEQ    'MXACSSTR2'                                  CSE029
     C                   CALLB     'MXACSSTR2'                                  CSE029
     C/COPY MXCPYSRC,MXACSPRME                                                  CSE029
                                                                                CSE029
     C     EXACSM        WHENEQ    'MXACSPSTD'                                                CSW025
     C                   CALLB     'MXACSPSTD'                                                CSW025
     C/COPY MXCPYSRC,MXACSPRME                                                                CSW025
     C     EXACSM        WHENEQ    'MXACSPSTX1'                                               CSW025
     C                   CALLB     'MXACSPSTX1'                                               CSW025
     C/COPY MXCPYSRC,MXACSPRME                                                                CSW025
                                                                                              CSW025
     C     EXACSM        WHENEQ    'MXACSPSTX2'                                               CSW025
     C                   CALLB     'MXACSPSTX2'                                               CSW025
     C/COPY MXCPYSRC,MXACSPRME                                                                CSW025
     C     EXACSM        WHENEQ    'MXACSBRCH'                                                CSE040
     C                   CALLB     'MXACSBRCH'                                                CSE040
     C/COPY MXCPYSRC,MXACSPRME                                                                CSE040
 
     C     EXACSM        WHENEQ    'MXACSRSTR'                                                CSE040
     C                   CALLB     'MXACSRSTR'                                                CSE040
     C/COPY MXCPYSRC,MXACSPRME                                                                CSE040
                                                                                              CER045
     C     EXACSM        WHENEQ    'MXACSACNO'                                                CER045
     C                   CALLB     'MXACSACNO'                                                CER045
     C/COPY MXCPYSRC,MXACSPRME                                                                CER045
                                                                                              CER045
     C     EXACSM        WHENEQ    'MXACSFCLT3'                                               CER045
     C                   CALLB     'MXACSFCLT3'                                               CER045
     C/COPY MXCPYSRC,MXACSPRME                                                                CER045
                                                                                              CER045
     C     EXACSM        WHENEQ    'MXACSFCLT4'                                               CER045
     C                   CALLB     'MXACSFCLT4'                                               CER045
     C/COPY MXCPYSRC,MXACSPRME                                                                CER045
                                                                                              CER045
     C     EXACSM        WHENEQ    'MXACSACUS'                                                CER045
     C                   CALLB     'MXACSACUS'                                                CER045
     C/COPY MXCPYSRC,MXACSPRME                                                                CER045
                                                                                              CER045
     C     EXACSM        WHENEQ    'MXACSDETT'                                                CER045
     C                   CALLB     'MXACSDETT'                                                CER045
     C/COPY MXCPYSRC,MXACSPRME                                                                CER045
 
     C     EXACSM        WHENEQ    'MXACSNOST'                                                CTI006
     C                   CALLB     'MXACSNOST'                                                CTI006
     C/COPY MXCPYSRC,MXACSPRME                                                                CTI006
     C     EXACSM        WHENEQ    'MXACSLOCN'                                                CTI006
     C                   CALLB     'MXACSLOCN'                                                CTI006
     C/COPY MXCPYSRC,MXACSPRME                                                                CTI006
     C     EXACSM        WHENEQ    'MXACSCORR'                                                CTI006
     C                   CALLB     'MXACSCORR'                                                CTI006
     C/COPY MXCPYSRC,MXACSPRME                                                                CTI006
     C     EXACSM        WHENEQ    'MXACSTICS'                                                CTI006
     C                   CALLB     'MXACSTICS'                                                CTI006
     C/COPY MXCPYSRC,MXACSPRME                                                                CTI006
     C     EXACSM        WHENEQ    'MXACSHOLD'                                                CTI006
     C                   CALLB     'MXACSHOLD'                                                CTI006
     C/COPY MXCPYSRC,MXACSPRME                                                                CTI006
     C     EXACSM        WHENEQ    'MXACSCTR2'                                                CTI006
     C                   CALLB     'MXACSCTR2'                                                CTI006
     C/COPY MXCPYSRC,MXACSPRME                                                                CTI006
     C     EXACSM        WHENEQ    'MXACSTIMUL'                                               CTI006
     C                   CALLB     'MXACSTIMUL'                                               CTI006
     C/COPY MXCPYSRC,MXACSPRME                                                                CTI006
     C     EXACSM        WHENEQ    'MXACSBANK'                                                CTI006
     C                   CALLB     'MXACSBANK'                                                CTI006
     C/COPY MXCPYSRC,MXACSPRME                                                                CTI006
     C     EXACSM        WHENEQ    'MXACSBHOL'                                                CTI006
     C                   CALLB     'MXACSBHOL'                                                CTI006
     C/COPY MXCPYSRC,MXACSPRME                                                                CTI006
     C     EXACSM        WHENEQ    'MXACSHBRC'                                                CTI006
     C                   CALLB     'MXACSHBRC'                                                CTI006
     C/COPY MXCPYSRC,MXACSPRME                                                                CTI006
     C     EXACSM        WHENEQ    'MXACSDELT'                                                CTI006
     C                   CALLB     'MXACSDELT'                                                CTI006
     C/COPY MXCPYSRC,MXACSPRME                                                                CTI006
                                                                                              CTI006
     C     CMX012        WHENEQ    'Y'                                                        CMX012
     C     EXACSM        ANDNE     *BLANKS                                                    CMX012
     C                   CALLB     'MXEXCPPGM'                                                CMX012
      * Pass the access module and the other standard export parameters                       CMX012
     C                   PARM                    EXACSM                                       CMX012
     C/COPY MXCPYSRC,MXACSPRME                                                                CMX012
 
     C                   OTHER
 
      * The access module is mandatory only for ACTIVITY composites
      * or for formats that are NOT the driver format
 
 
     C     I#EXTT        IFEQ      'A'
     C     CFLFMT        ORNE      '*DRIVER   '
     C                   EVAL      I#ERMS = CFFMT + ': BAD ACCESS MODULE'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     *BLANK        ACS_RTCD
     C                   ENDIF
 
     C                   ENDSL
 
      * Error
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN FORMAT ' + CFFMT
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the 'driver' format has just been processed
 
     C     CFLFMT        IFEQ      '*DRIVER   '
 
      * End if it is NOT to be extracted
 
     C     ACS_RTCD      IFEQ      '*NOEXT '
     C                   EVAL      O#Sel_EXP = 'N'
     C                   RETURN
     C                   ENDIF
 
      * Update Input Data
 
     C                   EVAL      DRV_InData = InData
     C                   ENDIF
 
      * Format and Write MQ Series Data
 
     C     ACS_RTCD      IFNE      '*EODATA'
 
      * If this is a multiple format, subtract from the number of events
      * the count of events not selected
 
     C     CFFMT         IFEQ      'MXMULTPD '
     C                   MOVEL     Indata        Wrk5N             5 0
     C                   SUB       Cnt_NOTSel    Wrk5N
     C                   MOVEL     Wrk5N         Indata
     C                   Z-ADD     *ZERO         Cnt_NOTSel
     C                   ENDIF
 
     C                   MOVEL     CFSEQM        L_MQSEQM
     C                   MOVEL     CFFMT         L_MQFMT
     C                   MOVEL     CFMULT        L_MQMULT
 
     C                   EXSR      FMT_DATA
 
      * If the 'driver' format has just been processed
      * Set the reference and journal sequence on the message
      * and check whether to select this driver for export
 
     C     CFLFMT        IFEQ      '*DRIVER   '
     C                   MOVEL     ReferID       O#ReferID
     C                   MOVEL     ReferID       L_MQREF
     C                   MOVEL     I#REFS        L_MQREFS
     C     Select_EXP    IFNE      'Y'
     C                   EVAL      O#Sel_EXP = 'N'
     C                   RETURN
     C                   ELSE
     C                   EVAL      O#Sel_EXP = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      * Write to the MQ/Series Data file
      * if not a multiple format
      * or if a multiple format and the record has been selected for export
 
     C     CFEXPT        IFEQ      'Y'
     C     CFMULT        IFEQ      'N'
     C     CFMULT        OREQ      'Y'
     C     Select_EXP    ANDEQ     'Y'
     C                   EXSR      WRT_MQDT
     C                   ELSE
     C                   ADD       1             Cnt_NOTSel
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Set data extracted
 
     C                   EXSR      SET_DATA
 
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Derive Link-To Fields
      ********************************************************************
     C     DERIV_LFD     BEGSR
 
     C                   MOVEL     *BLANK        I#LFD1           20
     C                   MOVEL     *BLANK        I#LFD2           20
     C                   MOVEL     *BLANK        I#LFD3           20
     C                   MOVEL     *BLANK        I#LFD4           20
     C                   MOVEL     *BLANK        I#LFD5           20
     C                   MOVEL     *BLANK        I#LFD6           20
 
     C     CFLFMT        IFEQ      '*DRIVER   '
     C                   EVAL      ScData = DRV_InData
     C                   EVAL      InData = DRV_InData
     C                   ELSE
 
     C                   MOVE      CFLPRS        @PRSQ             2 0
 
     C                   SELECT
     C     @PRSQ         WHENEQ    01
     C                   EVAL      ScData = #_DATA01
     C     @PRSQ         WHENEQ    02
     C                   EVAL      ScData = #_DATA02
     C     @PRSQ         WHENEQ    03
     C                   EVAL      ScData = #_DATA03
     C     @PRSQ         WHENEQ    04
     C                   EVAL      ScData = #_DATA04
     C     @PRSQ         WHENEQ    05
     C                   EVAL      ScData = #_DATA05
     C     @PRSQ         WHENEQ    06
     C                   EVAL      ScData = #_DATA06
     C     @PRSQ         WHENEQ    07
     C                   EVAL      ScData = #_DATA07
     C     @PRSQ         WHENEQ    08
     C                   EVAL      ScData = #_DATA08
     C     @PRSQ         WHENEQ    09
     C                   EVAL      ScData = #_DATA09
     C     @PRSQ         WHENEQ    10
     C                   EVAL      ScData = #_DATA10
     C     @PRSQ         WHENEQ    11
     C                   EVAL      ScData = #_DATA11
     C     @PRSQ         WHENEQ    12
     C                   EVAL      ScData = #_DATA12
     C     @PRSQ         WHENEQ    13
     C                   EVAL      ScData = #_DATA13
     C     @PRSQ         WHENEQ    14
     C                   EVAL      ScData = #_DATA14
     C     @PRSQ         WHENEQ    15
     C                   EVAL      ScData = #_DATA15
     C     @PRSQ         WHENEQ    16
     C                   EVAL      ScData = #_DATA16
     C     @PRSQ         WHENEQ    17
     C                   EVAL      ScData = #_DATA17
     C     @PRSQ         WHENEQ    18
     C                   EVAL      ScData = #_DATA18
     C     @PRSQ         WHENEQ    19
     C                   EVAL      ScData = #_DATA19
     C     @PRSQ         WHENEQ    20
     C                   EVAL      ScData = #_DATA20
     C                   ENDSL
 
     C                   ENDIF
 
 
      * Set up link fields for input to access module
 
     C     CFLBP1        IFNE      0
     C     CFLLN1        subst     ScData:CFLBP1 I#LFD1
     C                   ENDIF
     C     CFLBP2        IFNE      0
     C     CFLLN2        subst     ScData:CFLBP2 I#LFD2
     C                   ENDIF
     C     CFLBP3        IFNE      0
     C     CFLLN3        subst     ScData:CFLBP3 I#LFD3
     C                   ENDIF
     C     CFLBP4        IFNE      0
     C     CFLLN4        subst     ScData:CFLBP4 I#LFD4
     C                   ENDIF
     C     CFLBP5        IFNE      0
     C     CFLLN5        subst     ScData:CFLBP5 I#LFD5
     C                   ENDIF
     C     CFLBP6        IFNE      0
     C     CFLLN6        subst     ScData:CFLBP6 I#LFD6
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set data extracted
      ********************************************************************
     C     SET_DATA      BEGSR
 
     C                   SELECT
     C     CFPRSQ        WHENEQ    '01'
     C                   EVAL      #_DATA01 = Indata
     C     CFPRSQ        WHENEQ    '02'
     C                   EVAL      #_DATA02 = Indata
     C     CFPRSQ        WHENEQ    '03'
     C                   EVAL      #_DATA03 = Indata
     C     CFPRSQ        WHENEQ    '04'
     C                   EVAL      #_DATA04 = Indata
     C     CFPRSQ        WHENEQ    '05'
     C                   EVAL      #_DATA05 = Indata
     C     CFPRSQ        WHENEQ    '06'
     C                   EVAL      #_DATA06 = Indata
     C     CFPRSQ        WHENEQ    '07'
     C                   EVAL      #_DATA07 = Indata
     C     CFPRSQ        WHENEQ    '08'
     C                   EVAL      #_DATA08 = Indata
     C     CFPRSQ        WHENEQ    '09'
     C                   EVAL      #_DATA09 = Indata
     C     CFPRSQ        WHENEQ    '10'
     C                   EVAL      #_DATA10 = Indata
     C     CFPRSQ        WHENEQ    '11'
     C                   EVAL      #_DATA11 = Indata
     C     CFPRSQ        WHENEQ    '12'
     C                   EVAL      #_DATA12 = Indata
     C     CFPRSQ        WHENEQ    '13'
     C                   EVAL      #_DATA13 = Indata
     C     CFPRSQ        WHENEQ    '14'
     C                   EVAL      #_DATA14 = Indata
     C     CFPRSQ        WHENEQ    '15'
     C                   EVAL      #_DATA15 = Indata
     C     CFPRSQ        WHENEQ    '16'
     C                   EVAL      #_DATA16 = Indata
     C     CFPRSQ        WHENEQ    '17'
     C                   EVAL      #_DATA17 = Indata
     C     CFPRSQ        WHENEQ    '18'
     C                   EVAL      #_DATA18 = Indata
     C     CFPRSQ        WHENEQ    '19'
     C                   EVAL      #_DATA19 = Indata
     C     CFPRSQ        WHENEQ    '20'
     C                   EVAL      #_DATA20 = Indata
     C                   ENDSL
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * F O R M A T   D A T A
      /COPY MXCPYSRC,MXFMTDATA
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * W R I T E   P E R F O R M A N C E   L O G   D A T A
      /COPY MXCPYSRC,MXWRTPLOG
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * W R I T E   M Q   S E R I E S   D A T A
      /COPY MXCPYSRC,MXWRTMQDT
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Initialize the count of events not selected
 
     C                   Z-ADD     *ZERO         Cnt_NOTSel        5 0
 
      * Key Lists
 
     C     MXCOMDK       KLIST
     C                   KFLD                    I#COMI
     C                   KFLD                    I#EXTT
     C     MXCOMFK       KLIST
     C                   KFLD                    I#COMI
     C                   KFLD                    I#EXTT
 
      ** Access SAR details file to determine if CMX012 is on.                               CMX012
      *                                                                                      CMX012
     C                   CALLB     'AOSARDR0'                                                CMX012
     C                   PARM      *BLANKS       @RTCD                                       CMX012
     C                   PARM      '*VERIFY'     @OPTN                                       CMX012
     C                   PARM      'CMX012'      @SARD                                       CMX012
     C     SCSARD        PARM      SCSARD        DSFDY                                       CMX012
      *                                                                                      CMX012
     C     @RTCD         IFEQ      *BLANK                                                    CMX012
     C                   MOVE      'Y'           CMX012            1                         CMX012
     C                   ELSE                                                                CMX012
     C                   MOVE      'N'           CMX012                                      CMX012
     C                   END                                                                 CMX012
                                                                                             CMX012
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
