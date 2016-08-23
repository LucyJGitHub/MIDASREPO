     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management Detail Default')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDDCMTDFT - Document Management Default Details              *
      *                                                               *
      *  Function:  This module retrieves customer details            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSD093   *CREATE   Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD093 - Document Management                                 *
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
 
      ** External DS for Non-Account Holder Details
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** External DS for Document Code Details
     D SDDOCM        E DS                  EXTNAME(SDDOCMPD)
 
      ** First DS for Access Programs, short Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7
     D POPTN           S              7
     D PCNUM           S             10
     D PNAHO           S             10
     D PCNST           S              7
     D PCUST           S             10
     D PRTYP           S              1
     D PCODE           S              2
     D PDCCD           S              2
     D PRefDet         S            800
     D PDocmDt         S            800
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C                   EVAL      PCNUM  = *BLANKS
     C                   EVAL      SDCUST = *BLANKS
     C                   EVAL      SDNAHO = *BLANKS
     C                   EVAL      SDDOCM = *BLANKS
 
     C                   IF        PRTYP = 'C'
      *
      ** Retrieve Customer Details
      *
     C                   EVAL      PCNUM = PCUST
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM                    PCNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      PNAHO = PCUST
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PNAHO
     C     SDNAHO        PARM      SDNAHO        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBASE  = 902
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PCODE <> *BLANKS
     C                   CALL      'AODOCMR2'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PCODE         PDCCD
     C     SDDOCM        PARM      SDDOCM        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      **  Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Customer number
     C                   PARM                    PCUST
 
      ** Reference Type
     C                   PARM                    PRTYP
 
      ** Document Code
     C                   PARM                    PCODE
 
      ** Customer Details
     C                   PARM                    SDCUST
 
      ** Non-account Holder Details
     C                   PARM                    SDNAHO
 
      ** Document Code Details
     C                   PARM                    SDDOCM
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDDCMTDFT'
     C                   EVAL      RetCodeIn = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2013
