     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients details validation 2')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSECD2VL - Security Customers Details Validation 2          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 ----------- Base ------------------------------*
      *  Last Amend No. 243070             Date 10Jul06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CSE042             Date 05Feb03               *
      *                 CSE041             Date 05Feb03               *
      *                 CSE039 *CREATE     Date 05Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  243070 - Recompile over changed PF/SDVSECDPD                 *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE042 - Auto Feed of Trades and Movements                   *
      *  CSE041 - DVP/RVP Processing                                  *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Midas SD Local Industry Codes
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDSEC2V001
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** Security Details in screen format
     D SecDets       E DS                  EXTNAME(SDSECDPD)
 
      ** Security Details OK indicators
     D OKSecDets2    E DS                  EXTNAME(SDESECD2PD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
 
     D ValidSecd     E DS                  EXTNAME(SDVSECDPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      * Valid Securities Clients Details layout
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSEC2V002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SDSEC2V003
 
      *
      ** Only validate CSE039, CSE041 and CSE042 fields
      ** if Classification is 'S' or 'D'.
      *
 
 B01 C     DDCLAS        IFEQ      'S'
     C     DDCLAS        OREQ      'D'
 
      *
      ** Validate the following fields if CSE039 is ON
      *  ---------------------------------------------
     C     CSE039        IFEQ      'Y'
 
      *
      ** Validate Settlement Advice Required
      *
      /COPY WNCPYSRC,SDSEC2V004
     C                   EXSR      VCSARQ
      /COPY WNCPYSRC,SDSEC2V005
      *
     C                   ENDIF
 
      *                                                                                       CSE041
      ** Validate the following fields if CSE041 is ON                                        CSE041
      *  ---------------------------------------------                                        CSE041
     C     CSE041        IFEQ      'Y'                                                        CSE041
                                                                                              CSE041
      *                                                                                       CSE041
      ** Validate Contractual Settlement Customer Group                                       CSE041
      *                                                                                       CSE041
      /COPY WNCPYSRC,SDSEC2V006                                                               CSE041
     C                   EVAL      SECSCG = DDCSCG                                            CSE041
      /COPY WNCPYSRC,SDSEC2V007                                                               CSE041
                                                                                              CSE041
      *                                                                                       CSE041
      ** Validate Contractual Settlement Required for DVP/RVP                                 CSE041
      *                                                                                       CSE041
      /COPY WNCPYSRC,SDSEC2V008                                                               CSE041
     C                   EXSR      VCCSVP                                                     CSE041
      /COPY WNCPYSRC,SDSEC2V009                                                               CSE041
      *                                                                                       CSE041
     C                   ENDIF                                                                CSE041
                                                                                              CSE041
      *                                                                                       CSE042
      ** Validate the following fields if CSE042 is ON                                        CSE042
      *  ---------------------------------------------                                        CSE042
     C     CSE042        IFEQ      'Y'                                                        CSE042
                                                                                              CSE042
      *                                                                                       CSE042
      ** Validate Error/Warning on Validation failure indicators                              CSE042
      *                                                                                       CSE042
      /COPY WNCPYSRC,SDSEC2V010                                                               CSE042
     C                   EXSR      VCEWVF                                                     CSE042
      /COPY WNCPYSRC,SDSEC2V011                                                               CSE042
                                                                                              CSE042
      *                                                                                       CSE042
      ** Validate Authorisation Required for STP Trades                                       CSE042
      *                                                                                       CSE042
      /COPY WNCPYSRC,SDSEC2V012                                                               CSE042
     C                   EXSR      VCARST                                                     CSE042
      /COPY WNCPYSRC,SDSEC2V013                                                               CSE042
      *                                                                                       CSE042
     C                   ENDIF                                                                CSE042
                                                                                              CSE042
      *                                                                                       CSE042
      ** Validate the following fields if CSE041 OR CSE042 is ON                              CSE042
      *  -------------------------------------------------------                              CSE042
     C     CSE041        IFEQ      'Y'                                                        CSE042
     C     CSE042        OREQ      'Y'                                                        CSE042
                                                                                              CSE042
      *                                                                                       CSE042
      ** Validate Auto-Forward Unmatched Trade Messages                                       CSE042
      *                                                                                       CSE042
      /COPY WNCPYSRC,SDSEC2V014                                                               CSE042
     C                   EXSR      VCAFUM                                                     CSE042
      /COPY WNCPYSRC,SDSEC2V015                                                               CSE042
                                                                                              CSE042
      *                                                                                       CSE042
      ** Validate Auto-Forward Failed Trade Messages                                          CSE042
      *                                                                                       CSE042
      /COPY WNCPYSRC,SDSEC2V016                                                               CSE042
     C                   EXSR      VCAFFM                                                     CSE042
      /COPY WNCPYSRC,SDSEC2V017                                                               CSE042
      *                                                                                       CSE042
     C                   ENDIF                                                                CSE042
 
 E01 C                   ENDIF
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDSEC2V018
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCSARQ
      *****************************************************************
     C     VCSARQ        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Settlement Advice Required
      *
     C                   CALLB     'SDVCSARQ'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Settlement Advice Required
     C     SESARQ        PARM                    DDSARQ
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Settlement Advice Required Indicator - OK
     C                   PARM                    DDSARQOK
 
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************                       CSE041
      ** VCCSVP                                                                               CSE041
      *****************************************************************                       CSE041
     C     VCCSVP        BEGSR                                                                CSE041
                                                                                              CSE041
      * Reset variables updated by validation                                                 CSE041
                                                                                              CSE041
     C                   EXSR      RESETERRS                                                  CSE041
      *                                                                                       CSE041
      ** Validate Contractual Settlement Required for DVP/RVP                                 CSE041
      *                                                                                       CSE041
     C                   CALLB     'SDVCCSVP'                                                 CSE041
      * INPUTS                                                                                CSE041
      *                                                                                       CSE041
      ** Return Code                                                                          CSE041
     C                   PARM                    RetCodeIn                                    CSE041
      *                                                                                       CSE041
      ** Other parms                                                                          CSE041
      *                                                                                       CSE041
      ** Contractual Settlement required for DVP/RVP                                          CSE041
     C     SECSVP        PARM                    DDCSVP                                       CSE041
      *                                                                                       CSE041
      *                                                                                       CSE041
      * OUTPUTS                                                                               CSE041
      *                                                                                       CSE041
      *                                                                                       CSE041
      * Error fields/message IDs/message data (arrays) from/to caller                         CSE041
     C                   PARM                    FldNamXAr                                    CSE041
     C                   PARM                    MsgIDXAr                                     CSE041
     C                   PARM                    MsgDtaXAr                                    CSE041
      *                                                                                       CSE041
      ** Contractual Settlement required for DVP/RVP Indicator - OK                           CSE041
     C                   PARM                    DDCSVPOK                                     CSE041
                                                                                              CSE041
      *                                                                                       CSE041
      * Update error info with that returned from the validation module                       CSE041
                                                                                              CSE041
     C                   EXSR      UPDATERRS                                                  CSE041
      *                                                                                       CSE041
     C                   ENDSR                                                                CSE041
      *****************************************************************                       CSE041
     C/EJECT                                                                                  CSE041
      *****************************************************************                       CSE042
      ** VCEWVF                                                                               CSE042
      *****************************************************************                       CSE042
     C     VCEWVF        BEGSR                                                                CSE042
                                                                                              CSE042
      * Reset variables updated by validation                                                 CSE042
                                                                                              CSE042
     C                   EXSR      RESETERRS                                                  CSE042
      *                                                                                       CSE042
      ** Validate Error/Warning on Validation failure indicators                              CSE042
      *                                                                                       CSE042
     C                   CALLB     'SDVCEWVF'                                                 CSE042
      * INPUTS                                                                                CSE042
      *                                                                                       CSE042
      ** Return Code                                                                          CSE042
     C                   PARM                    RetCodeIn                                    CSE042
      *                                                                                       CSE042
      ** Other parms                                                                          CSE042
      *                                                                                       CSE042
      ** Error/Warning on Validation failure indicators                                       CSE042
     C     SEEWVF        PARM                    DDEWVF                                       CSE042
      *                                                                                       CSE042
      *                                                                                       CSE042
      * OUTPUTS                                                                               CSE042
      *                                                                                       CSE042
      *                                                                                       CSE042
      * Error fields/message IDs/message data (arrays) from/to caller                         CSE042
     C                   PARM                    FldNamXAr                                    CSE042
     C                   PARM                    MsgIDXAr                                     CSE042
     C                   PARM                    MsgDtaXAr                                    CSE042
      *                                                                                       CSE042
      ** Error/Warning on Validation failure indicators Indicator - OK                        CSE042
     C                   PARM                    DDEWVFOK                                     CSE042
                                                                                              CSE042
      *                                                                                       CSE042
      * Update error info with that returned from the validation module                       CSE042
                                                                                              CSE042
     C                   EXSR      UPDATERRS                                                  CSE042
      *                                                                                       CSE042
     C                   ENDSR                                                                CSE042
      *****************************************************************                       CSE042
     C/EJECT                                                                                  CSE042
      *****************************************************************                       CSE042
      ** VCAFUM                                                                               CSE042
      *****************************************************************                       CSE042
     C     VCAFUM        BEGSR                                                                CSE042
                                                                                              CSE042
      * Reset variables updated by validation                                                 CSE042
                                                                                              CSE042
     C                   EXSR      RESETERRS                                                  CSE042
      *                                                                                       CSE042
      ** Validate Auto-Forward Unmatched Trade Messages                                       CSE042
      *                                                                                       CSE042
     C                   CALLB     'SDVCAFUM'                                                 CSE042
      * INPUTS                                                                                CSE042
      *                                                                                       CSE042
      ** Return Code                                                                          CSE042
     C                   PARM                    RetCodeIn                                    CSE042
      *                                                                                       CSE042
      ** Other parms                                                                          CSE042
      *                                                                                       CSE042
      ** Auto-Forward Unmatched Trade Messages                                                CSE042
     C     SEAFUM        PARM                    DDAFUM                                       CSE042
      *                                                                                       CSE042
      *                                                                                       CSE042
      * OUTPUTS                                                                               CSE042
      *                                                                                       CSE042
      *                                                                                       CSE042
      * Error fields/message IDs/message data (arrays) from/to caller                         CSE042
     C                   PARM                    FldNamXAr                                    CSE042
     C                   PARM                    MsgIDXAr                                     CSE042
     C                   PARM                    MsgDtaXAr                                    CSE042
      *                                                                                       CSE042
      ** Auto-Forward Unmatched Trade Messages Indicator - OK                                 CSE042
     C                   PARM                    DDAFUMOK                                     CSE042
                                                                                              CSE042
      *                                                                                       CSE042
      * Update error info with that returned from the validation module                       CSE042
                                                                                              CSE042
     C                   EXSR      UPDATERRS                                                  CSE042
      *                                                                                       CSE042
     C                   ENDSR                                                                CSE042
      *****************************************************************                       CSE042
     C/EJECT                                                                                  CSE042
      *****************************************************************                       CSE042
      ** VCAFFM                                                                               CSE042
      *****************************************************************                       CSE042
     C     VCAFFM        BEGSR                                                                CSE042
                                                                                              CSE042
      * Reset variables updated by validation                                                 CSE042
                                                                                              CSE042
     C                   EXSR      RESETERRS                                                  CSE042
      *                                                                                       CSE042
      ** Validate Auto-Forward Failed Trade Messages                                          CSE042
      *                                                                                       CSE042
     C                   CALLB     'SDVCAFFM'                                                 CSE042
      * INPUTS                                                                                CSE042
      *                                                                                       CSE042
      ** Return Code                                                                          CSE042
     C                   PARM                    RetCodeIn                                    CSE042
      *                                                                                       CSE042
      ** Other parms                                                                          CSE042
      *                                                                                       CSE042
      ** Auto-Forward Failed Trade Messages                                                   CSE042
     C     SEAFFM        PARM                    DDAFFM                                       CSE042
      *                                                                                       CSE042
      *                                                                                       CSE042
      * OUTPUTS                                                                               CSE042
      *                                                                                       CSE042
      *                                                                                       CSE042
      * Error fields/message IDs/message data (arrays) from/to caller                         CSE042
     C                   PARM                    FldNamXAr                                    CSE042
     C                   PARM                    MsgIDXAr                                     CSE042
     C                   PARM                    MsgDtaXAr                                    CSE042
      *                                                                                       CSE042
      ** Auto-Forward Failed Trade Messages Indicator - OK                                    CSE042
     C                   PARM                    DDAFFMOK                                     CSE042
                                                                                              CSE042
      *                                                                                       CSE042
      * Update error info with that returned from the validation module                       CSE042
                                                                                              CSE042
     C                   EXSR      UPDATERRS                                                  CSE042
      *                                                                                       CSE042
     C                   ENDSR                                                                CSE042
      *****************************************************************                       CSE042
     C/EJECT                                                                                  CSE042
      *****************************************************************                       CSE042
      ** VCARST                                                                               CSE042
      *****************************************************************                       CSE042
     C     VCARST        BEGSR                                                                CSE042
                                                                                              CSE042
      * Reset variables updated by validation                                                 CSE042
                                                                                              CSE042
     C                   EXSR      RESETERRS                                                  CSE042
      *                                                                                       CSE042
      ** Validate Authorisation Required for STP Trades                                       CSE042
      *                                                                                       CSE042
     C                   CALLB     'SDVCARST'                                                 CSE042
      * INPUTS                                                                                CSE042
      *                                                                                       CSE042
      ** Return Code                                                                          CSE042
     C                   PARM                    RetCodeIn                                    CSE042
      *                                                                                       CSE042
      ** Other parms                                                                          CSE042
      *                                                                                       CSE042
      ** Authorisation Required for STP Trades                                                CSE042
     C     SEARST        PARM                    DDARST                                       CSE042
      *                                                                                       CSE042
      *                                                                                       CSE042
      * OUTPUTS                                                                               CSE042
      *                                                                                       CSE042
      *                                                                                       CSE042
      * Error fields/message IDs/message data (arrays) from/to caller                         CSE042
     C                   PARM                    FldNamXAr                                    CSE042
     C                   PARM                    MsgIDXAr                                     CSE042
     C                   PARM                    MsgDtaXAr                                    CSE042
      *                                                                                       CSE042
      ** Authorisation Required for STP Trades Indicator - OK                                 CSE042
     C                   PARM                    DDARSTOK                                     CSE042
                                                                                              CSE042
      *                                                                                       CSE042
      * Update error info with that returned from the validation module                       CSE042
                                                                                              CSE042
     C                   EXSR      UPDATERRS                                                  CSE042
      *                                                                                       CSE042
     C                   ENDSR                                                                CSE042
      *****************************************************************                       CSE042
     C/EJECT                                                                                  CSE042
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Security Details
     C                   PARM                    SecDets
 
      ** Automatic Settlement of Trades
     C                   PARM                    CSE039            1
 
      ** DVP/RVP Processing                                                                   CSE041
     C                   PARM                    CSE041            1                          CSE041
                                                                                              CSE041
      ** Auto Feed of Trades and Movements                                                    CSE042
     C                   PARM                    CSE042            1                          CSE042
 
      * OUTPUTS
 
      ** Security Details OK inds
     C                   PARM                    OKSecDets2
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Valid Securities Clients details layout (DS) from/to caller
     C                   PARM                    ValidSecd
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDSEC2V019
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SDSECD2VL'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
