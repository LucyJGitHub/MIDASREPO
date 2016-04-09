     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Review Detail Default')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACRV1DT - Account Review Default Details                   *
      *                                                               *
      *  Function:  This module retrieves customer details            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      /COPY ZACPYSRC,STD_D_SPEC
 
      /COPY ZACPYSRC,STDDECLARE
 
      /COPY ZACPYSRC,PSDS
 
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
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** First DS for Access Programs, short Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WCNUM           S             10
     D WCNST           S              7
     D PCUST           S              6
     D PDetails        S            800
     D WRTCD           S              7
     D WOPTN           S              7
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C                   MOVE      *BLANKS       WCNUM
     C                   MOVE      *BLANKS       PDetails
     C                   MOVEL     PCUST         WCNUM
 
      ** Validate Customer
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM                    WCNUM
     C                   PARM                    WCNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        WRTCD <> *BLANKS
     C                   MOVE      '*ERROR'      RetCodeIn
     C                   ELSE
     C                   EVAL      PDetails = SDCUST
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      **  Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Customer number
     C                   PARM                    PCUST
 
      ** SDCUSTPD details
     C                   PARM                    PDetails
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDACRV1DT'
     C                   EVAL      RetCodeIn = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2014
