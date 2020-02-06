     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE Agency Trades Sett. - Update APITRANSPD')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading                                   *
      *                                                               *
      *  SE4320B - Process Output to APITRANSPD                       *
      *                                                               *
      *  Function:  This program will write a record to APITRANSPD    *
      *             for the settlement of Trades.                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW213             Date 03Jun13               *
      *                 CFT039             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSE039  *CREATE    Date 08Apr03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank. Increase      *
      *           BUFFER size as per new APITRANSPD length.           *
      *  CSE039 - Automatic Settlement Trades                         *
      *                                                               *
      *****************************************************************
      /EJECT
 
     FAPITRANSPDO    E             DISK
      ** API Transaction file
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Data structure for Settlement Trades Formats
     D*BUFFER***       DS          6000                                                       CFT039
     D***BUFFER*         DS         12000                                              CFT039 CSW213
     D BUFFER          DS         29997                                                       CSW213
     D  DATA                   1    472
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ****************************************************************
      *                                                              *
      *  Main processing                                             *
      *                                                              *
      ****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    PTRAN           472
 
      ** Output details of from Entry Parm to APITRANSPD
     C                   MOVEL     PTRAN         DATA
     C                   WRITE     APITRANSD0
 
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2003
