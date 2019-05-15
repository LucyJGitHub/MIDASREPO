     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Calculate Purchased Interest    (not use)')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  SEVCSPI - Calculate Purchased Interest                       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 05May06               *
      *                 234440  *CREATE    Date 21Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  234440 - Purchase Interest should be maintained during input *
      *           cycle                                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FCPOSC     IF   E           K DISK    INFSR(*pssr)
 
     FCDEPP     IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Working variable
     D WkAvAmt         S             15P 0
     D WkCSPI          S             30P 4
     D*WCnum****       S              6S 0                                                   CSD027A
     D WCnum           S              6A                                                     CSD027A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Defaulting
 
     C                   EXSR      Default
 
      ** Return
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Default - Purchased Interest Default                         *
      *****************************************************************
     C     Default       BEGSR
 
     C     KEYCPD        CHAIN     CPOSC                              34
     C                   IF        *IN34 = *ON
     C                   Z-ADD     0             CSNV
     C                   Z-ADD     0             CSPI
     C                   ENDIF
     C                   Z-ADD     CSPI          WrkCSPI
      *
      ** Walk Ins and Trade Sales - add purchase interest
      *
     C                   IF        WType = 'WI' OR WType = 'TS'
 
     C                   IF        WAction = 'D'
     C                   EVAL      WrkCSPI = WrkCSPI - WPInt
     C                   ELSE
     C                   EVAL      WrkCSPI = WrkCSPI + WPInt
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Walk Outs and Trade Purchases - subtract a proportion of the
      ** purchased interest
      *
     C                   IF        WType = 'WO' OR WType = 'TP'
 
     C                   Z-ADD     CSNV          WkAvAmt
 
      ** Get Customer Depot Position for Changes to Nominal Amount Today
 
     C     KEYCPD        SETLL     CDEPP
     C     KEYCPD        READE     CDEPP                                  35
     C                   Z-ADD     0             WrkNP
     C                   Z-ADD     0             WrkNS
 
     C     *IN35         DOWEQ     '0'
     C                   ADD       SNPT          WrkNP
     C                   ADD       CDST          WrkNS
     C     KEYCPD        READE     CDEPP                                  35
     C                   ENDDO
 
     C                   EVAL      WkAvAmt = WkAvAmt + WrkNS + WrkNP
 
     C                   IF        WkAvAmt = 0
     C                   Z-ADD     0             WkCSPI
     C                   ELSE
     C     WAmt          MULT      CSPI          WkCSPI
     C     WkCSPI        IFLT      0
     C                   Z-SUB     WkCSPI        WkCSPI
     C                   ENDIF
     C     WkCSPI        DIV       WkAvAmt       WkCSPI
 
     C                   ENDIF
 
     C                   IF        WAction = 'D'
     C                   EVAL      WrkCSPI = WrkCSPI + WkCSPI
     C                   ELSE
     C                   EVAL      WrkCSPI = WrkCSPI - WkCSPI
     C                   ENDIF
 
     C                   END
 
     C     EndDft        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
 
      ** Received Parameters
      ** -------------------
 
     C                   PARM                    WAction           1
     C                   PARM                    WBrca
     C                   PARM                    WCnum
     C                   PARM                    WSesn
     C                   PARM                    WType             2
     C                   PARM                    WAmt             11 0
     C                   PARM                    WPInt            11 0
 
      ** OUTPUTS
      ** Purchase Interest
 
     C                   PARM                    WrkCSPI
 
     C     KEYCPD        KLIST
     C                   KFLD                    WBrca             3
     C                   KFLD                    WCnum
     C                   KFLD                    WSesn            10
 
     C     *LIKE         DEFINE    SNPT          WrkNP
     C     *LIKE         DEFINE    CDST          WrkNS
     C     *LIKE         DEFINE    CSPI          WrkCSPI
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
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
(c) Finastra International Limited 2005
