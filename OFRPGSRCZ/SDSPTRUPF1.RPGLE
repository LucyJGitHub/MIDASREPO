     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ACTGRP(*CALLER) DFTACTGRP(*NO)                               *
/*EXI *  TEXT('Midas OF FT Payment Charge Definitions Update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDSPTRUPF1 - Midas SD Payment Charge Definitions Update      *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Function : This program allows the maintenance of payment    *
      *             charge details                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD032880           Date 12Aug15               *
      *                 259785             Date 14Jan13               *
      *                 CFT147  *CREATE    Date 14Jan13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD032880 - API: FTPCHGPD not updated by SPTR                 *
      *  259785 - Fix for CFT147.                                     *
      *           Base Ccy amounts calc'd from max value "other ccy"  *
      *           amounts are exceeding field size.  Add              *
      *           conditioning so that if 1) other currency amount    *
      *           is max then make base ccy amount max.  2) if        *
      *           calculated base ccy amount exceeds max, reduce it   *
      *           to max value.                                       *
      *  CFT147 - Automatic update of payment charges definitions     *
      *                                                               *
      *****************************************************************
      *
      ** Midas FT Payment Charge Definition by Currency
      *
     FFTPCHGW0  UF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      ** +--------------------------------------+
      ** Î Automatically included D-specs       Î
      ** Î ==============================       Î
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

      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *

     D/COPY ZACPYSRC,PSDS

      *
      ** Program, procedure and module names for parameters
      ** ==================================================
      *

      ** +--------------------------------------+
      ** Î End of automatically included D-specsÎ
      ** Î =====================================Î
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** Î Manually included D-specs            Î
      ** Î =========================            Î
      ** +--------------------------------------+

      *
      ** Work Variables
      *
     D W#CCY           S              3A
     D W#INPAMT        S             15  0
     D W#FRMCCY        S              3
     D W#TOCCY         S              3
     D W#OUTAMT        S             15  0
     D W#SRTM          S             26A
     D P#SRTM          S             26A
      *
     D W#FRMDEC        S              1P 0
     D W#TODEC         S              1P 0
     D W#MDIND         S                   LIKE(A6MDIN)
     D W#CVTRAT        S                   LIKE(A6SPRT)
      *
     D W#HIVAL13       S             13  0                                                    259785
      *                                                                                       259785
      ** Parameters for calling Access Objects
      *
     D PRTCD           S              7A
     D POPTN           S              7A
     D PCCY            S              7A

      ** +--------------------------------------+
      ** Î Arrays and Data Structures           Î
      ** Î ==========================           Î
      ** +--------------------------------------+

      *
      ** EXTERNAL DS FOR BANK DETAILS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External data structure for currency codes
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** Î Named constants                      Î
      ** Î ===============                      Î
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** Î Declared variables                   Î
      ** Î ==================                   Î
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** Î End of D-specs                       Î
      ** Î ==============                       Î
      ** +--------------------------------------+

      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** Î                                                                Î
      ** Î Initial processing is performed automatically: the *INZSR is   Î
      ** Î executed at program activation.                                Î
      ** Î                                                                Î
      ** +----------------------------------------------------------------+
      *****************************************************************
      *
     C/EJECT
      *
     C**********         IF        W#SRTM = P#SRTM                                          MD032880
     C                   EXSR      SRMAIN
     C**********         ENDIF                                                              MD032880
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    W#CCY
     C                   PARM                    P#SRTM
      *
     C                   EVAL      W#FRMCCY = W#CCY
     C                   EVAL      W#HIVAL13 = *HIVAL
      *
      ** Get Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDSPTRUPF1'  DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** Get Currency Details for Base Currency (To Ccy)
      *
     C                   EVAL      W#TOCCY = BJCYCD
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      W#TOCCY       PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDSPTRUPF1'  DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     W#TOCCY       DBKEY
     C                   MOVEL     '002'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVEL     A6NBDP        W#TODEC
      *
      ** Get Currency Details for Input Currency
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      W#FRMCCY      PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDSPTRUPF1'  DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     W#FRMCCY      DBKEY
     C                   MOVEL     '003'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C                   MOVEL     A6SPRT        W#CVTRAT
     C                   MOVEL     A6NBDP        W#FRMDEC
     C                   MOVEL     A6MDIN        W#MDIND
     C                   MOVEL     A6SRTM        W#SRTM
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAIN - Main Subroutine                                     *
      *                                                               *
      *  Calls: SRRANG1, SRRANG2, SRRANG3, SRRANG4, SRRANG5,          *
      *         SRRANG6, SRRANG7, SRRANG8, SRRANG9, SRRANG10,         *
      *         SROUTRNG, SRUPDAT
      *                                                               *
      *****************************************************************
      *
     C     SRMAIN        BEGSR
      *
     C     W#CCY         SETLL     FTPCHGW0
      *
     C                   IF        %EQUAL()
      *
     C     W#CCY         READE     FTPCHGW0
     C                   DOW       NOT%EOF(FTPCHGW0)
      *
     C                   EXSR      SRRANG1
     C                   EXSR      SRRANG2
     C                   EXSR      SRRANG3
     C                   EXSR      SRRANG4
     C                   EXSR      SRRANG5
     C                   EXSR      SRRANG6
     C                   EXSR      SRRANG7
     C                   EXSR      SRRANG8
     C                   EXSR      SRRANG9
     C                   EXSR      SRRANG10
     C                   EXSR      SROUTRNG
      *
      ** Update file FTPCHGPD
     C                   EXSR      SRUPDAT
      *
     C     W#CCY         READE     FTPCHGW0
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCONV - Convert Amount to Base Currency                     *
      *                                                               *
      *  Called By: SRRANG1, SRRANG2, SRRANG3, SRRANG4, SRRANG5,      *
      *             SRRANG6, SRRANG7, SRRANG8, SRRANG9, SRRANG10,     *
      *             SROUTRNG                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCONV        BEGSR
      *
     C                   CALL      'ZCONVZ1'
     C                   PARM                    W#INPAMT
     C                   PARM                    W#CVTRAT
     C                   PARM                    W#MDIND
     C                   PARM                    W#FRMCCY
     C                   PARM                    W#TOCCY
     C                   PARM                    W#FRMDEC
     C                   PARM                    W#TODEC
     C                   PARM      *ZEROS        W#OUTAMT
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDAT - Update FTPCHGW0                                    *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRUPDAT       BEGSR
      *
     C                   UPDATE(E) FTPCHGD0
      *
     C                   IF        %ERROR()
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDSPTRUPF1'  DBPGM
     C                   MOVEL     'FTPCHGPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     PYCHCD        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRANG1 - Calculate Amount for Base Currency Range 1         *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: SRCONV                                                *
      *                                                               *
      *****************************************************************
     C     SRRANG1       BEGSR
      *
      ** Calculate Start Amount Base Currency Range 1.
      *
     C                   EVAL      W#INPAMT = STOC01
     C                   IF        W#INPAMT = *ZEROS
     C                   MOVEL     *ZEROS        SABC01
     C                   ELSE
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SABC01 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SABC01 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SABC01 = W#OUTAMT
     C                   ENDIF
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate End Amount Base currency Range 1.
      *
     C                   EVAL      W#INPAMT = ENOC01
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      EABC01 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      EABC01 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      EABC01 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Minimum Charge Base Currency Range 1.
      *
     C                   EVAL      W#INPAMT = MIOC01
     C                   IF        W#INPAMT = *ZEROS
     C                   MOVEL     *ZEROS        MIBC01
     C                   ELSE
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MIBC01 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MIBC01 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MIBC01 = W#OUTAMT
     C                   ENDIF
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Maximum Charge Base Currency Range 1.
      *
     C                   EVAL      W#INPAMT = MAOC01
     C                   IF        W#INPAMT = *ZEROS
     C                   MOVEL     *ZEROS        MXBC01
     C                   ELSE
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MXBC01 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MXBC01 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MXBC01 = W#OUTAMT
     C                   ENDIF
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Start Amount Base Currency Range 1.
      *
     C                   EVAL      W#INPAMT = SSOC01
     C                   IF        W#INPAMT = *ZEROS
     C                   MOVEL     *ZEROS        SSBC01
     C                   ELSE
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SSBC01 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSBC01 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSBC01 = W#OUTAMT
     C                   ENDIF
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP End Amount Base currency Range 1.
      *
     C                   EVAL      W#INPAMT = SEOC01
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SSEC01 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSEC01 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSEC01 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Minimum Charge Base Currency Range 1.
      *
     C                   EVAL      W#INPAMT = SMIO01
     C                   IF        W#INPAMT = *ZEROS
     C                   MOVEL     *ZEROS        SMIB01
     C                   ELSE
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMIB01 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMIB01 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMIB01 = W#OUTAMT
     C                   ENDIF
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Maximum Charge Base Currency Range 1.
      *
     C                   EVAL      W#INPAMT = SMAC01
     C                   IF        W#INPAMT = *ZEROS
     C                   MOVEL     *ZEROS        SMAB01
     C                   ELSE
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMAB01 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMAB01 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMAB01 = W#OUTAMT
     C                   ENDIF
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRANG2 - Calculate Amount for Base Currency Range 2         *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: SRCONV                                                *
      *                                                               *
      *****************************************************************
     C     SRRANG2       BEGSR
      *
     C                   IF        STOC02 <> *ZEROS
      *
      ** Calculate Start Amount Base Currency Range 2.
      *
     C***************    EVAL      W#INPAMT = STOC02                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SABC02 = W#OUTAMT                                          259785
     C***************    IF        (SABC02 <> (EABC01 + 1))                                   259785
     C                   IF        EABC01 = W#HIVAL13                                         259785
     C                   EVAL      SABC02 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SABC02 = EABC01 + 1
     C                   ENDIF
      *
      ** Calculate End Amount Base currency Range 2.
      *
     C                   EVAL      W#INPAMT = ENOC02
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      EABC02 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      EABC02 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      EABC02 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Minimum Charge Base Currency Range 2.
      *
     C                   EVAL      W#INPAMT = MIOC02
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MIBC02 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MIBC02 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MIBC02 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Maximum Charge Base Currency Range 2.
      *
     C                   EVAL      W#INPAMT = MAOC02
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MXBC02 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MXBC02 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MXBC02 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   IF        SSOC02 <> *ZEROS
      *
      ** Calculate STP Start Amount Base Currency Range 2.
      *
     C***************    EVAL      W#INPAMT = SSOC02                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SSBC02 = W#OUTAMT                                          259785
     C***************    IF        (SSBC02 <> (SSEC01 + 1))                                   259785
     C                   IF        SSEC01 = W#HIVAL13                                         259785
     C                   EVAL      SSBC02 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSBC02 = SSEC01 + 1
     C                   ENDIF
      *
      ** Calculate STP End Amount Base currency Range 2.
      *
     C                   EVAL      W#INPAMT = SEOC02
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SSEC02 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSEC02 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSEC02 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Minimum Charge Base Currency Range 2.
      *
     C                   EVAL      W#INPAMT = SMIO02
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMIB02 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSEC02 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMIB02 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Maximum Charge Base Currency Range 2.
      *
     C                   EVAL      W#INPAMT = SMAC02
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMAB02 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMAB02 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMAB02 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRANG3 - Calculate Amount for Base Currency Range 3         *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: SRCONV                                                *
      *                                                               *
      *****************************************************************
     C     SRRANG3       BEGSR
      *
     C                   IF        STOC03 <> *ZEROS
      *
      ** Calculate Start Amount Base Currency Range 3.
      *
     C***************    EVAL      W#INPAMT = STOC03                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SABC03 = W#OUTAMT                                          259785
     C***************    IF        (SABC03 <> (EABC02 + 1))                                   259785
     C                   IF        EABC02 = W#HIVAL13                                         259785
     C                   EVAL      SABC03 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SABC03 = EABC02 + 1
     C                   ENDIF
      *
      ** Calculate End Amount Base currency Range 3.
      *
     C                   EVAL      W#INPAMT = ENOC03
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      EABC03 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      EABC03 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      EABC03 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Minimum Charge Base Currency Range 3.
      *
     C                   EVAL      W#INPAMT = MIOC03
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MIBC03 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MIBC03 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MIBC03 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Maximum Charge Base Currency Range 3.
      *
     C                   EVAL      W#INPAMT = MAOC03
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MXBC03 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MXBC03 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MXBC03 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   IF        SSOC03 <> *ZEROS
      *
      ** Calculate STP Start Amount Base Currency Range 3.
      *
     C***************    EVAL      W#INPAMT = SSOC03                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SSBC03 = W#OUTAMT                                          259785
     C***************    IF        (SSBC03 <> (SSEC02 + 1))                                   259785
     C                   IF        SSEC02 = W#HIVAL13                                         259785
     C                   EVAL      SSBC03 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSBC03 = SSEC02 + 1
     C                   ENDIF
      *
      ** Calculate STP End Amount Base currency Range 3.
      *
     C                   EVAL      W#INPAMT = SEOC03
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SSEC03 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSEC03 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSEC03 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Minimum Charge Base Currency Range 3.
      *
     C                   EVAL      W#INPAMT = SMIO03
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMIB03 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMIB03 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMIB03 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Maximum Charge Base Currency Range 3.
      *
     C                   EVAL      W#INPAMT = SMAC03
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMAB03 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMAB03 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMAB03 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRANG4 - Calculate Amount for Base Currency Range 4         *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: SRCONV                                                *
      *                                                               *
      *****************************************************************
     C     SRRANG4       BEGSR
      *
     C                   IF        SABC04 <> *ZEROS
      *
      ** Calculate Start Amount Base Currency Range 4.
      *
     C***************    EVAL      W#INPAMT = STOC04                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SABC04 = W#OUTAMT                                          259785
     C***************    IF        (SABC04 <> (EABC03 + 1))                                   259785
     C                   IF        EABC03 = W#HIVAL13                                         259785
     C                   EVAL      SABC04 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SABC04 = EABC03 + 1
     C                   ENDIF
      *
      ** Calculate End Amount Base currency Range 4.
      *
     C                   EVAL      W#INPAMT = ENOC04
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      EABC04 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      EABC04 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      EABC04 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Minimum Charge Base Currency Range 4.
     C                   EVAL      W#INPAMT = MIOC04
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MIBC04 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MIBC04 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MIBC04 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Maximum Charge Base Currency Range 4.
      *
     C                   EVAL      W#INPAMT = MAOC04
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MXBC04 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MXBC04 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MXBC04 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   IF        SSOC04 <> *ZEROS
      *
      ** Calculate STP Start Amount Base Currency Range 4.
      *
     C***************    EVAL      W#INPAMT = SSOC04                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SSBC04 = W#OUTAMT                                          259785
     C***************    IF        (SSBC04 <> (SSEC03 + 1))                                   259785
     C                   IF        SSEC03 = W#HIVAL13                                         259785
     C                   EVAL      SSBC04 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSBC04 = SSEC03 + 1
     C                   ENDIF
      *
      ** Calculate STP End Amount Base currency Range 4.
      *
     C                   EVAL      W#INPAMT = SEOC04
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SSEC04 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSEC04 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSEC04 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Minimum Charge Base Currency Range 4.
      *
     C                   EVAL      W#INPAMT = SMIO04
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMIB04 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMIB04 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMIB04 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Maximum Charge Base Currency Range 4.
      *
     C                   EVAL      W#INPAMT = SMAC04
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMAB04 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMAB04 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMAB04 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRANG5 - Calculate Amount for Base Currency Range 5         *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: SRCONV                                                *
      *                                                               *
      *****************************************************************
     C     SRRANG5       BEGSR
      *
     C                   IF        STOC05 <> *ZEROS
      *
      ** Calculate Start Amount Base Currency Range 5.
      *
     C***************    EVAL      W#INPAMT = STOC05                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SABC05 = W#OUTAMT                                          259785
     C***************    IF        (SABC05 <> (EABC04 + 1))                                   259785
     C                   IF        EABC04 = W#HIVAL13                                         259785
     C                   EVAL      SABC05 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SABC05 = EABC04 + 1
     C                   ENDIF
      *
      ** Calculate End Amount Base currency Range 5.
      *
     C                   EVAL      W#INPAMT = ENOC05
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      EABC05 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      EABC05 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      EABC05 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Minimum Charge Base Currency Range 5.
      *
     C                   EVAL      W#INPAMT = MIOC05
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MIBC05 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MIBC05 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MIBC05 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Maximum Charge Base Currency Range 5.
      *
     C                   EVAL      W#INPAMT = MAOC05
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MXBC05 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MXBC05 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MXBC05 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   IF        SSOC05 <> *ZEROS
      *
      ** Calculate STP Start Amount Base Currency Range 5.
      *
     C***************    EVAL      W#INPAMT = SSOC05                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SSBC05 = W#OUTAMT                                          259785
     C***************    IF        (SSBC05 <> (SSEC04 + 1))                                   259785
     C                   IF        SSEC04 = W#HIVAL13                                         259785
     C                   EVAL      SSBC05 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSBC05 = SSEC04 + 1
     C                   ENDIF
      *
      ** Calculate STP End Amount Base currency Range 5.
      *
     C                   EVAL      W#INPAMT = SEOC05
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SSEC05 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSEC05 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSEC05 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Minimum Charge Base Currency Range 5.
      *
     C                   EVAL      W#INPAMT = SMIO05
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMIB05 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMIB05 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMIB05 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Maximum Charge Base Currency Range 5.
      *
     C                   EVAL      W#INPAMT = SMAC05
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMAB05 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMAB05 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMAB05 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRANG6 - Calculate Amount for Base Currency Range 6         *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: SRCONV                                                *
      *                                                               *
      *****************************************************************
     C     SRRANG6       BEGSR
      *
     C                   IF        STOC06 <> *ZEROS
      *
      ** Calculate Start Amount Base Currency Range 6.
      *
     C***************    EVAL      W#INPAMT = STOC06                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SABC06 = W#OUTAMT                                          259785
     C***************    IF        (SABC06 <> (EABC05 + 1))                                   259785
     C                   IF        EABC05 = W#HIVAL13                                         259785
     C                   EVAL      SABC06 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SABC06 = EABC05 + 1
     C                   ENDIF
      *
      ** Calculate End Amount Base currency Range 6.
      *
     C                   EVAL      W#INPAMT = ENOC06
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      EABC06 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      EABC06 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      EABC06 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Minimum Charge Base Currency Range 6.
      *
     C                   EVAL      W#INPAMT = MIOC06
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MIBC06 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MIBC06 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MIBC06 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Maximum Charge Base Currency Range 6.
      *
     C                   EVAL      W#INPAMT = MAOC06
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MXBC06 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MXBC06 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MXBC06 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   IF        SSOC06 <> *ZEROS
      *
      ** Calculate STP Start Amount Base Currency Range 6.
      *
     C***************    EVAL      W#INPAMT = SSOC06                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SSBC06 = W#OUTAMT                                          259785
     C***************    IF        (SSBC06 <> (SSEC05 + 1))                                   259785
     C                   IF        SSEC05 = W#HIVAL13                                         259785
     C                   EVAL      SSBC06 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSBC06 = SSEC05 + 1
     C                   ENDIF
      *
      ** Calculate STP End Amount Base currency Range 6.
      *
     C                   EVAL      W#INPAMT = SEOC06
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SSEC06 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSEC06 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSEC06 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Minimum Charge Base Currency Range 6.
      *
     C                   EVAL      W#INPAMT = SMIO06
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMIB06 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMIB06 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMIB06 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Maximum Charge Base Currency Range 6.
      *
     C                   EVAL      W#INPAMT = SMAC06
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMAB06 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMAB06 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMAB06 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRANG7 - Calculate Amount for Base Currency Range 7         *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: SRCONV                                                *
      *                                                               *
      *****************************************************************
     C     SRRANG7       BEGSR
      *
     C                   IF        STOC07 <> *ZEROS
      *
      ** Calculate Start Amount Base Currency Range 7.
      *
     C***************    EVAL      W#INPAMT = STOC07                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SABC07 = W#OUTAMT                                          259785
     C***************    IF        (SABC07 <> (EABC06 + 1))                                   259785
     C                   IF        EABC06 = W#HIVAL13                                         259785
     C                   EVAL      SABC07 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SABC07 = EABC06 + 1
     C                   ENDIF
      *
      ** Calculate End Amount Base currency Range 7.
      *
     C                   EVAL      W#INPAMT = ENOC07
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      EABC07 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      EABC07 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      EABC07 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Minimum Charge Base Currency Range 7.
      *
     C                   EVAL      W#INPAMT = MIOC07
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MIBC07 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MIBC07 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MIBC07 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Maximum Charge Base Currency Range 7.
      *
     C                   EVAL      W#INPAMT = MAOC07
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MXBC07 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MXBC07 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MXBC07 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   IF        SSOC07 <> *ZEROS
      *
      ** Calculate STP Start Amount Base Currency Range 7.
      *
     C***************    EVAL      W#INPAMT = SSOC07                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SSBC07 = W#OUTAMT                                          259785
     C***************    IF        (SSBC07 <> (SSEC06 + 1))                                   259785
     C                   IF        SSEC06 = W#HIVAL13                                         259785
     C                   EVAL      SSBC07 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSBC07 = SSEC06 + 1
     C                   ENDIF
      *
      ** Calculate STP End Amount Base currency Range 7.
      *
     C                   EVAL      W#INPAMT = SEOC07
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SSEC07 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSEC07 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSEC07 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Minimum Charge Base Currency Range 7.
      *
     C                   EVAL      W#INPAMT = SMIO07
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMIB07 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMIB07 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMIB07 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Maximum Charge Base Currency Range 7.
      *
     C                   EVAL      W#INPAMT = SMAC07
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMAB07 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMAB07 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMAB07 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRANG8 - Calculate Amount for Base Currency Range 8         *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: SRCONV                                                *
      *                                                               *
      *****************************************************************
     C     SRRANG8       BEGSR
      *
     C                   IF        STOC08 <> *ZEROS
      *
      ** Calculate Start Amount Base Currency Range 8.
      *
     C***************    EVAL      W#INPAMT = STOC08                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SABC08 = W#OUTAMT                                          259785
     C***************    IF        (SABC08 <> (EABC07 + 1))                                   259785
     C                   IF        EABC07 = W#HIVAL13                                         259785
     C                   EVAL      SABC08 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SABC08 = EABC07 + 1
     C                   ENDIF
      *
      ** Calculate End Amount Base currency Range 8.
      *
     C                   EVAL      W#INPAMT = ENOC08
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      EABC08 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      EABC08 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      EABC08 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Minimum Charge Base Currency Range 8.
      *
     C                   EVAL      W#INPAMT = MIOC08
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MIBC08 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MIBC08 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MIBC08 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Maximum Charge Base Currency Range 8.
      *
     C                   EVAL      W#INPAMT = MAOC08
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MXBC08 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MXBC08 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MXBC08 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   IF        SSOC08 <> *ZEROS
      *
      ** Calculate STP Start Amount Base Currency Range 8.
      *
     C***************    EVAL      W#INPAMT = SSOC08                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SSBC08 = W#OUTAMT                                          259785
     C***************    IF        (SSBC08 <> (SSEC07 + 1))                                   259785
     C                   IF        SSEC07 = W#HIVAL13                                         259785
     C                   EVAL      SSBC08 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSBC08 = SSEC07 + 1
     C                   ENDIF
      *
      ** Calculate STP End Amount Base currency Range 8.
      *
     C                   EVAL      W#INPAMT = SEOC08
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SSEC08 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSEC08 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSEC08 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Minimum Charge Base Currency Range 8.
      *
     C                   EVAL      W#INPAMT = SMIO08
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMIB08 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMIB08 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMIB08 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Maximum Charge Base Currency Range 8.
      *
     C                   EVAL      W#INPAMT = SMAC08
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMAB08 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMAB08 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMAB08 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRANG9 - Calculate Amount for Base Currency Range 9         *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: SRCONV                                                *
      *                                                               *
      *****************************************************************
     C     SRRANG9       BEGSR
      *
     C                   IF        STOC09 <> *ZEROS
      *
      ** Calculate Start Amount Base Currency Range 9.
      *
     C***************    EVAL      W#INPAMT = STOC09                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SABC09 = W#OUTAMT                                          259785
     C***************    IF        (SABC09 <> (EABC08 + 1))                                   259785
     C                   IF        EABC08 = W#HIVAL13                                         259785
     C                   EVAL      SABC09 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SABC09 = EABC08 + 1
     C                   ENDIF
      *
      ** Calculate End Amount Base currency Range 9.
      *
     C                   EVAL      W#INPAMT = ENOC09
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      EABC09 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      EABC09 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      EABC09 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Minimum Charge Base Currency Range 9.
      *
     C                   EVAL      W#INPAMT = MIOC09
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MIBC09 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MIBC09 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MIBC09 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Maximum Charge Base Currency Range 9.
      *
     C                   EVAL      W#INPAMT = MAOC09
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MXBC09 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MXBC09 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MXBC09 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   IF        SSOC09 <> *ZEROS
      *
      ** Calculate STP Start Amount Base Currency Range 9.
      *
     C***************    EVAL      W#INPAMT = SSOC09                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SSBC09 = W#OUTAMT                                          259785
     C***************    IF        (SSBC09 <> (SSEC08 + 1))                                   259785
     C                   IF        SSEC08 = W#HIVAL13                                         259785
     C                   EVAL      SSBC09 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSBC09 = SSEC08 + 1
     C                   ENDIF
      *
      ** Calculate STP End Amount Base currency Range 9.
      *
     C                   EVAL      W#INPAMT = SEOC09
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SSEC09 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSEC09 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSEC09 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Minimum Charge Base Currency Range 9.
      *
     C                   EVAL      W#INPAMT = SMIO09
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMIB09 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMIB09 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMIB09 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Maximum Charge Base Currency Range 9.
      *
     C                   EVAL      W#INPAMT = SMAC09
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMAB09 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMAB09 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMAB09 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRANG10 - Calculate Amount for Base Currency Range 10       *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: SRCONV                                                *
      *                                                               *
      *****************************************************************
     C     SRRANG10      BEGSR
      *
     C                   IF        STOC10 <> *ZEROS
      *
      ** Calculate Start Amount Base Currency Range 10.
      *
     C***************    EVAL      W#INPAMT = STOC10                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SABC10 = W#OUTAMT                                          259785
     C***************    IF        (SABC10 <> (EABC09 + 1))                                   259785
     C                   IF        EABC09 = W#HIVAL13                                         259785
     C                   EVAL      SABC10 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SABC10 = EABC09 + 1
     C                   ENDIF
      *
      ** Calculate End Amount Base currency Range 10.
      *
     C                   EVAL      W#INPAMT = ENOC10
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      EABC10 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      EABC10 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      EABC10 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Minimum Charge Base Currency Range 10.
      *
     C                   EVAL      W#INPAMT = MIOC10
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MIBC10 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MIBC10 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MIBC10 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate Maximum Charge Base Currency Range 10.
      *
     C                   EVAL      W#INPAMT = MAOC10
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      MXBC10 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      MXBC10 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      MXBC10 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   IF        SSOC10 <> *ZEROS
      *
      ** Calculate STP Start Amount Base Currency Range 10.
      *
     C***************    EVAL      W#INPAMT = SSOC10                                          259785
     C***************    EXSR      SRCONV                                                     259785
     C***************    EVAL      SSBC10 = W#OUTAMT                                          259785
     C***************    IF        (SSBC10 <> (SSEC09 + 1))                                   259785
     C                   IF        SSEC09 = W#HIVAL13                                         259785
     C                   EVAL      SSBC10 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSBC10 = SSEC09 + 1
     C                   ENDIF
      *
      ** Calculate STP End Amount Base currency Range 10.
      *
     C                   EVAL      W#INPAMT = SEOC10
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SSEC10 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SSEC10 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SSEC10 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Minimum Charge Base Currency Range 10.
      *
     C                   EVAL      W#INPAMT = SMIO10
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMIB10 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMIB10 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMIB10 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Calculate STP Maximum Charge Base Currency Range 10.
      *
     C                   EVAL      W#INPAMT = SMAC10
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SMAB10 = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SMAB10 = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SMAB10 = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROUTRNG - Calculate Amount for Base Currency Out of Band    *
      *             Range                                             *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls: SRCONV                                                *
      *                                                               *
      *****************************************************************
     C     SROUTRNG      BEGSR
      *
     C                   IF        OMIOC <> *ZEROS
      *
      ** Calculate Out of band minimum Base Currency.
      *
     C                   EVAL      W#INPAMT = OMIOC
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      OMIBC = W#HIVAL13                                          259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      OMIBC = W#HIVAL13                                          259785
     C                   ELSE                                                                 259785
     C                   EVAL      OMIBC = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** Out of band maximum Base Currency.
      *
     C                   EVAL      W#INPAMT = OMAOC
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      OMABC = W#HIVAL13                                          259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      OMABC = W#HIVAL13                                          259785
     C                   ELSE                                                                 259785
     C                   EVAL      OMABC = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   IF        SOMIOC <> *ZEROS
      *
      ** STP Out of band minimum Base Currency.
      *
     C                   EVAL      W#INPAMT = SOMIOC
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SOMIBC = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SOMIBC = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SOMIBC = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
      ** STP Out of band maximum Base Currency.
      *
     C                   EVAL      W#INPAMT = SOMAOC
      *                                                                                       259785
     C                   IF        W#INPAMT = W#HIVAL13                                       259785
     C                   EVAL      SOMABC = W#HIVAL13                                         259785
      *                                                                                       259785
     C                   ELSE                                                                 259785
      *                                                                                       259785
     C                   EXSR      SRCONV
      *                                                                                       259785
     C                   IF        W#OUTAMT > W#HIVAL13                                       259785
     C                   EVAL      SOMABC = W#HIVAL13                                         259785
     C                   ELSE                                                                 259785
     C                   EVAL      SOMABC = W#OUTAMT
     C                   ENDIF                                                                259785
      *                                                                                       259785
     C                   ENDIF                                                                259785
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C/COPY ZACPYSRC,PSSR_ILENE
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
