     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Execution Venue')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  SDV0001 - Midas SD Validate Execution Venue                  *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD022702           Date 04Oct13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022702 - Error encountered when previous entry was invalid.*
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the FX standard declares
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** Named constant used to check LEI first 18 characters
     D ALPHA           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 
      ** Named constant used to check LEI last 2 characters
     D DIGITS          C                   '1234567890'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
 
      ** External DS for Market Identification Code
     D SDMICC        E DS                  EXTNAME(SDMICCPD)
 
      ** DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ExecVenue       S             35A
     D ExecVenueOK     S              1A
     D Length          S              2  0
     D Rtcd            S              7A
     D Optn            S              7A
     D PCusn           S             10A
     D PKyst           S              7A
     D Letters         S              2  0
     D Numbers         S              2  0
     D PChar18         S             18A
     D PMic            S              4A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EVAL      ExecVenueOK = *BLANKS                                    MD022702
     C     ' '           CHECKR    ExecVenue     Length
      *
      ** Check if the value entered is a valid customer
      *
     C                   IF        Length = 6 OR Length = 10
 
     C                   MOVEL     ExecVenue     PCusn
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      '*KEY'        Optn
     C                   PARM                    PCusn
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        Rtcd <> *BLANKS
     C                   EVAL      ExecVenueOK = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      *
      ** Check if the value entered is a valid LEI
      *
     C                   IF        Length = 20
 
     C     Alpha         CHECK     ExecVenue     Letters
     C     Digits        CHECK     ExecVenue:19  Numbers                  98
 
     C                   IF        Letters < 19 OR
     C                             *IN98 = *ON AND
     C                             Numbers <= 20
     C                   EVAL      ExecVenueOK = 'N'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Check if the value entered is a valid BIC
      *
     C                   IF        Length = 8 OR
     C                             Length = 11
 
     C                   MOVEL     ExecVenue     PChar18
     C                   CALLB     'AOBICDV01'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM                    PChar18
     C                   PARM      *BLANKS       PKySt
     C     MEBICD        PARM      MEBICD        DSSDY
 
     C                   IF        Rtcd <> *BLANKS
     C                   EVAL      ExecVenueOK = 'N'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Check if the value entered is a valid MIC
      *
     C                   IF        Length = 4
 
     C                   MOVEL     ExecVenue     PMic
     C                   CALLB     'AOMICCR0'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      '*KEY   '     Optn
     C                   PARM                    PMic
     C     SDMICC        PARM      SDMICC        DSFDY
 
     C                   IF        Rtcd <> *BLANKS
     C                   EVAL      ExecVenueOK = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Length <> 6  AND
     C                             Length <> 10 AND
     C                             Length <> 8  AND
     C                             Length <> 11 AND
     C                             Length <> 20 AND
     C                             Length <> 4
     C                   EVAL      ExecVenueOK = 'N'
     C                   ENDIF
      *
      ** Return to calling program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
     C                   PARM                    ExecVenue
     C                   PARM                    ExecVenueOK
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
