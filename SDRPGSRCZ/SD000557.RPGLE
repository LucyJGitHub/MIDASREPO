     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint Account Member Indicia')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000557 - Midas SD Joint Account Member Indicia             *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD040867           Date 26Aug16               *
      *  Prev Amend No. CGL177             Date 11Jan16               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040867 - Database encountered when a Joint Acct cust (with *
      *             Joint Acct Members containing Multiple Countries) *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

      ** Midas SD Joint Account Member
     FSDJACCL0  IF   E           K DISK

      ** Midas SD Joint Account Member                                                        CGL177
     FSDJACCL1  IF   E           K DISK                                                       CGL177
     F                                     PREFIX(J1:2)                                       CGL177
     F                                     RENAME(SDJACCD0:SDJACCD1)                          CGL177
                                                                                              CGL177
      ** Midas SD Joint Account Member                                                        CGL177
     FSDJACCL2  IF   E           K DISK                                                       CGL177
     F                                     PREFIX(J2:2)                                       CGL177
     F                                     RENAME(SDJACCD0:SDJACCD2)                          CGL177
                                                                                              CGL177
      ** Midas SD Joint Account Member                                                        CGL177
     FSDJACCL3  IF   E           K DISK                                                       CGL177
     F                                     PREFIX(J3:2)                                       CGL177
     F                                     RENAME(SDJACCD0:SDJACCD3)                          CGL177
                                                                                              CGL177
      ** Midas SD CRS Customer details
     FSDCRSDL2  IF   E           K DISK

      ** Midas SD CRS Non account holder details
     FSDCRSNL2  IF   E           K DISK

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE

      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** CRS Details File Format
     D SDCRSD        E DS                  EXTNAME(SDCRSDPD)

      ** CRS Details File Format
     D SDCRSN        E DS                  EXTNAME(SDCRSNPD)

      ** Joint Account File Format
     D SDJACC        E DS                  EXTNAME(SDJACCPD)

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PCountry        S              2A   DIM(30)
     D PMember         S              6A   DIM(999)                                           CGL177
     D DDCUST          S              6A
     D DDCTRY          S              2A
     D DDJACM          S              1A
     D KDCUST          S              6A
     D KDNAHO          S             10A
     D KDCTRY          S              2A
     D WRUN            S              1A
     D X               S              2S 0
     D WWCUS1          S              6A                                                      CGL177
     D WWCUS2          S              6A                                                      CGL177
     D WWCUS3          S              6A                                                      CGL177
     D KDCUS1          S              6A                                                      CGL177
     D KDCUS2          S              6A                                                      CGL177
     D KDCUS3          S              6A                                                      CGL177
     D KDNAH1          S             10A                                                      CGL177
     D KDNAH2          S             10A                                                      CGL177
     D KDNAH3          S             10A                                                      CGL177

      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

     C                   EVAL      DDJACM = ' '
     C                   EVAL      X = 1

      ** Read through Joint account members of the Customer
     C     DDCUST        SETLL     SDJACCD0
     C     DDCUST        READE     SDJACCD0

     C                   DOW       NOT %EOF(SDJACCL0)
     C                             AND DDCUST = JCJANO

     C                   IF        JCCUST <> *BLANKS
     C                   EVAL      WWCUS1 = JCCUST                                            CGL177
     C                   EVAL      KDCUST = JCCUST
     C     KDCUST        SETLL     SDCRSDD0
     C     KDCUST        READE     SDCRSDD0

     C                   DOW       NOT %EOF(SDCRSDL2)
     C                             AND KDCUST = CDCUST
     C                             AND X < 30                                               MD040867

     C                   IF        CDREPT = 'Y'                                               CGL177
     C                             AND %LOOKUP(CDCTRY:PCountry) = 0                         MD040867
     C                   EVAL      DDJACM = 'Y'
     C                   EVAL      PCountry(X) = CDCTRY
     C                   EVAL      X = X + 1
     C                   ENDIF
     C                   CLEAR                   SDCRSD
     C     KDCUST        READE     SDCRSDD0
     C                   ENDDO

      ** Second level check                                                                   CGL177
                                                                                              CGL177
      ** Read through Joint account members of the Customer                                   CGL177
     C     WWCUS1        SETLL     SDJACCD1                                                   CGL177
     C     WWCUS1        READE     SDJACCD1                                                   CGL177
                                                                                              CGL177
     C                   DOW       NOT %EOF(SDJACCL1)                                         CGL177
     C                             AND WWCUS1 = J1JANO                                        CGL177
                                                                                              CGL177
     C                   IF        J1CUST <> *BLANKS                                          CGL177
     C                   EVAL      KDCUS1 = J1CUST                                            CGL177
     C                   EVAL      WWCUS2 = J1CUST                                            CGL177
     C     KDCUS1        SETLL     SDCRSDD0                                                   CGL177
     C     KDCUS1        READE     SDCRSDD0                                                   CGL177
                                                                                              CGL177
     C                   DOW       NOT %EOF(SDCRSDL2)                                         CGL177
     C                             AND KDCUS1 = CDCUST                                        CGL177
     C                             AND X < 30                                               MD040867
                                                                                              CGL177
     C                   IF        CDREPT = 'Y'                                               CGL177
     C                             AND %LOOKUP(CDCTRY:PCountry) = 0                         MD040867
     C                   EVAL      DDJACM = 'Y'                                               CGL177
     C                   EVAL      PCountry(X) = CDCTRY                                       CGL177
     C                   EVAL      X = X + 1                                                  CGL177
     C                   ENDIF                                                                CGL177
     C                   CLEAR                   SDCRSD                                       CGL177
     C     KDCUS1        READE     SDCRSDD0                                                   CGL177
     C                   ENDDO                                                                CGL177
                                                                                              CGL177
      ** Third level check                                                                    CGL177
                                                                                              CGL177
      ** Read through Joint account members of the Customer                                   CGL177
     C     WWCUS2        SETLL     SDJACCD2                                                   CGL177
     C     WWCUS2        READE     SDJACCD2                                                   CGL177
                                                                                              CGL177
     C                   DOW       NOT %EOF(SDJACCL2)                                         CGL177
     C                             AND WWCUS2 = J2JANO                                        CGL177
                                                                                              CGL177
     C                   IF        J2CUST <> *BLANKS                                          CGL177
     C                   EVAL      KDCUS2 = J2CUST                                            CGL177
     C     KDCUS2        SETLL     SDCRSDD0                                                   CGL177
     C     KDCUS2        READE     SDCRSDD0                                                   CGL177
                                                                                              CGL177
     C                   DOW       NOT %EOF(SDCRSDL2)                                         CGL177
     C                             AND KDCUS2 = CDCUST                                        CGL177
     C                             AND X < 30                                               MD040867
                                                                                              CGL177
     C                   IF        CDREPT = 'Y'                                               CGL177
     C                             AND %LOOKUP(CDCTRY:PCountry) = 0                         MD040867
     C                   EVAL      DDJACM = 'Y'                                               CGL177
     C                   EVAL      PCountry(X) = CDCTRY                                       CGL177
     C                   EVAL      X = X + 1                                                  CGL177
     C                   ENDIF                                                                CGL177
     C                   CLEAR                   SDCRSD                                       CGL177
     C     KDCUS2        READE     SDCRSDD0                                                   CGL177
     C                   ENDDO                                                                CGL177
                                                                                              CGL177
      ** Fourth level check                                                                   CGL177
                                                                                              CGL177
      ** Read through Joint account members of the Customer                                   CGL177
     C     WWCUS3        SETLL     SDJACCD3                                                   CGL177
     C     WWCUS3        READE     SDJACCD3                                                   CGL177
                                                                                              CGL177
     C                   DOW       NOT %EOF(SDJACCL3)                                         CGL177
     C                             AND WWCUS3 = J3JANO                                        CGL177
                                                                                              CGL177
     C                   IF        J3CUST <> *BLANKS                                          CGL177
     C                   EVAL      KDCUS3 = J3CUST                                            CGL177
     C     KDCUS3        SETLL     SDCRSDD0                                                   CGL177
     C     KDCUS3        READE     SDCRSDD0                                                   CGL177
                                                                                              CGL177
     C                   DOW       NOT %EOF(SDCRSDL2)                                         CGL177
     C                             AND KDCUS3 = CDCUST                                        CGL177
     C                             AND X < 30                                               MD040867
                                                                                              CGL177
     C                   IF        CDREPT = 'Y'                                               CGL177
     C                             AND %LOOKUP(CDCTRY:PCountry) = 0                         MD040867
     C                   EVAL      DDJACM = 'Y'                                               CGL177
     C                   EVAL      PCountry(X) = CDCTRY                                       CGL177
     C                   EVAL      X = X + 1                                                  CGL177
     C                   ENDIF                                                                CGL177
     C                   CLEAR                   SDCRSD                                       CGL177
     C     KDCUS3        READE     SDCRSDD0                                                   CGL177
     C                   ENDDO                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   IF        J3NAHO <> *BLANKS                                          CGL177
     C                   EVAL      KDNAH3 = J3NAHO                                            CGL177
     C     KDNAH3        SETLL     SDCRSND0                                                   CGL177
     C     KDNAH3        READE     SDCRSND0                                                   CGL177
                                                                                              CGL177
     C                   DOW       NOT %EOF(SDCRSNL2)                                         CGL177
     C                             AND KDNAH3 = CNNAHO                                        CGL177
     C                             AND X < 30                                               MD040867
                                                                                              CGL177
     C                   IF        CNREPT = 'Y'                                               CGL177
     C                             AND %LOOKUP(CDCTRY:PCountry) = 0                         MD040867
     C                   EVAL      DDJACM = 'Y'                                               CGL177
     C                   EVAL      PCountry(X) = CNCTRY                                       CGL177
     C                   EVAL      X = X + 1                                                  CGL177
     C                   ENDIF                                                                CGL177
     C                   CLEAR                   SDCRSN                                       CGL177
     C     KDNAH3        READE     SDCRSND0                                                   CGL177
     C                   ENDDO                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   EVAL      J3CUST = *Blanks                                           CGL177
     C                   EVAL      J3NAHO = *Blanks                                           CGL177
     C     WWCUS3        READE     SDJACCD3                                                   CGL177
     C                   ENDDO                                                                CGL177
                                                                                              CGL177
      ** End of fourth level check                                                            CGL177
                                                                                              CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   IF        J2NAHO <> *BLANKS                                          CGL177
     C                   EVAL      KDNAH2 = J2NAHO                                            CGL177
     C     KDNAH2        SETLL     SDCRSND0                                                   CGL177
     C     KDNAH2        READE     SDCRSND0                                                   CGL177
                                                                                              CGL177
     C                   DOW       NOT %EOF(SDCRSNL2)                                         CGL177
     C                             AND KDNAH2 = CNNAHO                                        CGL177
     C                             AND X < 30                                               MD040867
                                                                                              CGL177
     C                   IF        CNREPT = 'Y'                                               CGL177
     C                             AND %LOOKUP(CDCTRY:PCountry) = 0                         MD040867
     C                   EVAL      DDJACM = 'Y'                                               CGL177
     C                   EVAL      PCountry(X) = CNCTRY                                       CGL177
     C                   EVAL      X = X + 1                                                  CGL177
     C                   ENDIF                                                                CGL177
     C                   CLEAR                   SDCRSN                                       CGL177
     C     KDNAH2        READE     SDCRSND0                                                   CGL177
     C                   ENDDO                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   EVAL      J2CUST = *Blanks                                           CGL177
     C                   EVAL      J2NAHO = *Blanks                                           CGL177
     C     WWCUS2        READE     SDJACCD2                                                   CGL177
     C                   ENDDO                                                                CGL177
                                                                                              CGL177
      ** End of third level check                                                             CGL177
                                                                                              CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   IF        J1NAHO <> *BLANKS                                          CGL177
     C                   EVAL      KDNAH1 = J1NAHO                                            CGL177
     C     KDNAH1        SETLL     SDCRSND0                                                   CGL177
     C     KDNAH1        READE     SDCRSND0                                                   CGL177
                                                                                              CGL177
     C                   DOW       NOT %EOF(SDCRSNL2)                                         CGL177
     C                             AND KDNAH1 = CNNAHO                                        CGL177
     C                             AND X < 30                                               MD040867
                                                                                              CGL177
     C                   IF        CNREPT = 'Y'                                               CGL177
     C                             AND %LOOKUP(CDCTRY:PCountry) = 0                         MD040867
     C                   EVAL      DDJACM = 'Y'                                               CGL177
     C                   EVAL      PCountry(X) = CNCTRY                                       CGL177
     C                   EVAL      X = X + 1                                                  CGL177
     C                   ENDIF                                                                CGL177
     C                   CLEAR                   SDCRSN                                       CGL177
     C     KDNAH1        READE     SDCRSND0                                                   CGL177
     C                   ENDDO                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   EVAL      J1CUST = *Blanks                                           CGL177
     C                   EVAL      J1NAHO = *Blanks                                           CGL177
     C     WWCUS1        READE     SDJACCD1                                                   CGL177
     C                   ENDDO                                                                CGL177
                                                                                              CGL177
      ** End of second level check                                                            CGL177

     C                   ENDIF

     C                   IF        JCNAHO <> *BLANKS
     C                   EVAL      KDNAHO = JCNAHO
     C     KDNAHO        SETLL     SDCRSND0
     C     KDNAHO        READE     SDCRSND0

     C                   DOW       NOT %EOF(SDCRSNL2)
     C                             AND KDNAHO = CNNAHO
     C                             AND X < 30                                               MD040867

     C                   IF        CNREPT = 'Y'                                               CGL177
     C                             AND %LOOKUP(CDCTRY:PCountry) = 0                         MD040867
     C                   EVAL      DDJACM = 'Y'
     C                   EVAL      PCountry(X) = CNCTRY
     C                   EVAL      X = X + 1
     C                   ENDIF
     C                   CLEAR                   SDCRSN
     C     KDNAHO        READE     SDCRSND0
     C                   ENDDO
     C                   ENDIF

     C                   CLEAR                   SDJACC
     C     DDCUST        READE     SDJACCD0
     C                   ENDDO

     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *Entry        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    DDCUST
     C                   PARM                    DDJACM
     C                   PARM                    PCountry

      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        WRUN = *Blanks
     C                   EVAL      WRUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

