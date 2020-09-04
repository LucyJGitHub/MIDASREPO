     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Upload to BF - Entitlements')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000060 - Upload to BF - Entitlements                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. MD022486           Date 20Sep13               *
      *  Prev Amend No. MD020456           Date 23May13               *
      *                 MD019911           Date 07Apr13               *
      *                 AR1085933          Date 06Feb13               *
      *                 AR989186           Date 06Feb13               *
      *                 AR958654           Date 02May12               *
      *                 AR924843           Date 08Mar12               *
      *                 AR883210           Date 21Dec11               *
      *                 CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022486 - Post User Security MASS Migration - Entitlements  *
      *             Missing                                           *
      *  MD020456 - BF Upload menu option UPLD doesn't upload         *
      *             entitlements to BFTB tables                       *
      *  MD019911 - Use SMBFUBPD as basis for entitlements upload     *
      *  AR1085933 - Get next available PK for BFIDPK                 *
      *  AR989186 - Insert record only if not already existing        *
      *           - Applied for AR1085933                             *
      *  AR958654 - Dynamic PK Generation (Child:AR958655)            *
      *  AR924843 - Entitlement Type 'Branch' as Booking Branch       *
      *  AR883210 - Additional Deliverables for BF                    *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *
     D UsrNam          S             10
     D Brch            S              3                                                     MD019911
     D BranchOK        S              1  0                                                  MD019911
     D BrFound         S              3  0                                                  MD019911
     D BrCount         S              3  0                                                  MD019911
     D j               S              3  0                                                  MD019911
     D RoleOK          S              3  0                                                  MD019911
     D ZnStmQry        S            256                                                     MD019911
     D EntVal          S              3
     D GrpId           S             30
     D GName           S             30
     D*Enttyp***       S             50    INZ('BookingBranch')                             AR924843
     D Enttyp2         S             50    INZ('Branch')
     D Description     S             30    INZ('')                                          MD022486
     D VerNum          S              9  0 INZ(1)
     D AppId           S              9    INZ('MIDAS')
     D IdPkNum         S             30  0 INZ(0)
     D USERS           S             10
     D PkCount         S              1  0 INZ(0)                                           AR958654
     D EntCount        S              1  0 INZ(0)                                           AR989186
      *
      ** 4 zones of 900 branches : Max                                                      MD019911
     DBranches         S              3A   Dim(3600)                                        MD019911
     DVBRX             S           2700A                                                    MD019911
     DAllVBRX          S          10800A                                                    MD019911
      *                                                                                     MD019911
     D Recursive       S              1    INZ('N')
      *
     D*USER          E DS                  EXTNAME(SMBFUDPD)
     D BRANCH        E DS                  EXTNAME(SMBFUBPD)
     D ZONES         E DS                  EXTNAME(GPZONEPD)                                MD019911
      *
     C*/*EXEC*SQL******************************************************                     MD019911
     C*+*DECLARE*UScursor*CURSOR*FOR***********************************                     MD019911
     C*+*SELECT*DISTINCT(UDUSER)***************************************                     MD019911
     C*+*FROM*SMBFUDPD*************************************************                     MD019911
     C*/*END-EXEC******************************************************                     MD019911
      *****************************************************************                     MD019911
     C*/*EXEC*SQL******************************************************                     MD019911
     C*+**OPEN*UScursor************************************************                     MD019911
     C*/*END-EXEC******************************************************                     MD019911
      *****************************************************************                     MD019911
     C*/*EXEC*SQL******************************************************                     MD019911
     C*+*FETCH*NEXT****************************************************                     MD019911
     C*+*FROM*UScursor*************************************************                     MD019911
     C*+*INTO:*USERS***************************************************                     MD019911
     C*/*END-EXEC******************************************************                     MD019911
                                                                                            MD019911
      /free                                                                                 MD019911
        Exec SQL                                                                          //MD019911
        Declare UBCursor cursor for                                                       //MD019911
           Select UBUSER, UBBRCH, UBROLE from SMBFUBPD                                    //MD019911
             where UBROLE <> '';                                                          //MD019911
                                                                                          //MD019911
        Exec SQL                                                                          //MD019911
        Open UBCursor;                                                                    //MD019911
                                                                                          //MD019911
        Exec SQL                                                                          //MD019911
        Fetch next from UBCursor                                                          //MD019911
        into :BRANCH;                                                                     //MD019911
      /end-free                                                                             MD019911
      *
      ** Initialise IdPkNum
     C                   EVAL      IdPkNum = 0
      *
     C                   DOW       SQLCODE = 0
      *
     C**********         EVAL      UsrNam = USERS                                           MD019911
      **********                                                                            MD019911
     C**********         EXSR      RtvBrch                                                  MD019911
      /free                                                                                 MD019911
           UsrNam = UBUSER;                                                               //MD019911
           GName = UBROLE;                                                                //MD019911
           Brch = UBBRCH;                                                                 //MD019911
                                                                                          //MD019911
           ExSr ChkBrch;                                                                  //MD019911
                                                                                          //MD019911
           If BRFound <> 0;                                                               //MD019911
              EntVal = UBBRCH;                                                            //MD019911
              ExSr ChkRole;                                                               //MD019911
                                                                                          //MD019911
              If RoleOK <> 0;                                                             //MD019911
                 ExSr GenEnt;                                                             //MD019911
              EndIf;                                                                      //MD019911
           EndIf;                                                                         //MD019911
                                                                                          //MD019911
        Exec SQL                                                                          //MD019911
        Fetch next from UBCursor                                                          //MD019911
        into :BRANCH;                                                                     //MD019911
      /end-free                                                                             MD019911
     C*/*EXEC*SQL******************************************************                     MD019911
     C*+*FETCH*NEXT****************************************************                     MD019911
     C*+*FROM*UScursor*************************************************                     MD019911
     C*+*INTO:*USERS***************************************************                     MD019911
     C*/*END-EXEC******************************************************                     MD019911
      *
     C                   ENDDO
      *
     C/EXEC SQL
     C*+*CLOSE UScursor                                                                     MD019911
     C+ CLOSE UBcursor                                                                      MD019911
     C/END-EXEC
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT                                                                                MD019911
      *****************************************************************                     MD019911
      *                                                               *                     MD019911
      *  ChkBrch - Check branch againsts allocation                   *                     MD019911
      *                                                               *                     MD019911
      *****************************************************************                     MD019911
      /free                                                                                 MD019911
          BegSr ChkBrch;                                                                  //MD019911
            BrFound = 0;                                                                  //MD019911
            Branches = *Blanks;                                                           //MD019911
            Exec SQL                                                                      //MD019911
              Declare ZN cursor for                                                       //MD019911
              Select * from GPZONEPD;                                                     //MD019911
            Exec SQL Open ZN;                                                             //MD019911
            Exec SQL Fetch next from ZN into :ZONES;                                      //MD019911
            ZnStmQry = '';                                                                //MD019911
                                                                                          //MD019911
            DoW SQLCODE = 0;                                                              //MD019911
                If %len(%trim(ZnStmQry)) > 0;                                             //MD019911
                ZnStmQry = %trim(ZnStmQry) + ' Union ';                                   //MD019911
                EndIf;                                                                    //MD019911
                ZnStmQry = %trim(ZnStmQry) + ' select trim(VBRX) from '                   //MD019911
                            + %trim(ZOMSYS) + 'DTALIB/MBRBSDD '                           //MD019911
                            + 'where USRP = ''' + %trim(UsrNam) +'''';                    //MD019911
                Exec SQL Fetch next from ZN into :ZONES;                                  //MD019911
            EndDo;                                                                        //MD019911
            Exec SQL Close ZN;                                                            //MD019911
                                                                                          //MD019911
            Exec SQL Prepare Z1 from :ZnStmQry;                                           //MD019911
            Exec SQL Declare Z2 cursor for Z1;                                            //MD019911
            Exec SQL Open Z2;                                                             //MD019911
            Exec SQL Fetch next from Z2 into :VBRX;                                       //MD019911
            DoW  SQLCODE = 0;                                                             //MD019911
                 AllVBRX = %trim(AllVBRX) + %trim(VBRX);                                  //MD019911
                 Exec SQL Fetch next from Z2 into :VBRX;                                  //MD019911
            EndDo;                                                                        //MD019911
                                                                                          //MD019911
           //Move VBRX into array for lookup                                              //MD019911
            BrCount = %len(%trim(AllVBRX)) / 3;                                           //MD019911
            For j = 1 to BrCount;                                                         //MD019911
                Branches(j) = %subst(AllVBRX:1+((j-1)*3):3);                              //MD019911
            EndFor;                                                                       //MD019911
                                                                                          //MD019911
            BrFound = %LOOKUP(Brch:Branches);                                             //MD019911
          EndSr;                                                                          //MD019911
      /end-free                                                                             MD019911
      /EJECT
      *****************************************************************                     MD019911
      *                                                               *                     MD019911
      *  ChkRole - Check role if exists and is assigned to user       *                     MD019911
      *                                                               *                     MD019911
      *****************************************************************                     MD019911
      /free                                                                                 MD019911
          BegSr ChkRole;                                                                  //MD019911
            RoleOK = 0;                                                                   //MD019911
            Exec SQL                                                                      //MD019911
            Select count(*) into :RoleOK from BFTB_ORGGROUPUSER a                         //MD019911
              where a.BFGROUPID =                                                         //MD019911
                       (select BFGROUPIDPK from BFTB_ORGANISATIONGRP                      //MD019911
                         where BFGROUPIDPK = a.BFGROUPID                                  //MD019911
                           and BFGROUPNAME = :GName)                                      //MD019911
                and a.BFUSERNAME = :UsrNam;                                               //MD019911
          EndSr;                                                                          //MD019911
      /end-free                                                                             MD019911
      *****************************************************************                     MD019911
      *****************************************************************                     MD019911
      ***RtvGrp*-*Retrieve*group***************************************                     MD019911
      *****************************************************************                     MD019911
      *****************************************************************                     MD019911
     C*****RtvGrp********BEGSR*****************************************                     MD019911
      *****************************************************************                     MD019911
     C*/EXEC*SQL*******************************************************                     MD019911
     C*+*DECLARE*GRcursor*CURSOR*FOR***********************************                     MD019911
     C*+*SELECT*BFGROUPID*FROM*BFTB_ORGGROUPUSER***********************                     MD019911
     C*+*WHERE*BFUSERNAME*=*:UsrNam************************************                     MD019911
     C*/END-EXEC*******************************************************                     MD019911
      *****************************************************************                     MD019911
     C*/EXEC*SQL*******************************************************                     MD019911
     C*+*OPEN*GRcursor*************************************************                     MD019911
     C*/END-EXEC*******************************************************                     MD019911
      *****************************************************************                     MD019911
     C*/EXEC*SQL*******************************************************                     MD019911
     C*+*FETCH*NEXT****************************************************                     MD019911
     C*+*FROM*GRcursor*************************************************                     MD019911
     C*+*INTO:*GrpId***************************************************                     MD019911
     C*/END-EXEC*******************************************************                     MD019911
      *****************************************************************                     MD019911
     C*/EXEC*SQL*******************************************************                     MD019911
     C*+*SELECT*BFGROUPNAME*INTO*:GName*FROM*BFTB_ORGANISATIONGRP******                     MD019911
     C*+*WHERE*BFGROUPIDPK*=*:GrpId************************************                     MD019911
     C*/END-EXEC*******************************************************                     MD019911
     C*******************DOW*******SQLCODE*=*0*************************                     MD019911
      *****************************************************************                     MD019911
      *                                                               *                     MD019911
      *  GenEnt - Generate Entitlements                               *                     MD019911
      *                                                               *                     MD019911
      *****************************************************************                     MD019911
     C     GenEnt        BEGSR                                                              MD019911
      *
     C/EXEC SQL                                                                             AR989186
     C+ select count(*) into :EntCount from BFTB_ENTITLEMENTS                               AR989186
     C+ where BFGROUPNAME = :GName                                                          AR989186
     C+ and   BFUSERNAME = :UsrNam                                                          AR989186
     C+ and   BFENTITLEMENTVALUE = :EntVal                                                  AR989186
     C/END-EXEC                                                                             AR989186
      *                                                                                     AR989186
     C                   IF        EntCount = 0                                             AR989186
      *                                                                                     AR958654
     C/EXEC SQL                                                                             AR958654
     C+ select count(*) into :PkCount from BFTB_ENTITLEMENTS                                AR958654
     C*+*where*BFIDPK*=*:IdPkNum***************************************            AR958654 MD022486
     C+ where BFIDPK = CHAR(:IdPkNum)                                                       MK022486
     C/END-EXEC                                                                             AR958654
     C**********         IF        PkCount > 0                                    AR958654 AR1085933
      *                                                                                    AR1085933
     C                   DOW       PkCount > 0                                             AR1085933
     C                   EVAL      IdPkNum = IdPkNum + 1
      *                                                                                    AR1085933
     C/EXEC SQL                                                                            AR1085933
     C+ select count(*) into :PkCount from BFTB_ENTITLEMENTS                               AR1085933
     C*+*where*BFIDPK*=*:IdPkNum***************************************           AR1085933 MD022486
     C+ where BFIDPK = CHAR(:IdPkNum)                                                       MD022486
     C/END-EXEC                                                                            AR1085933
      *                                                                                    AR1085933
     C                   ENDDO                                                             AR1085933
      *                                                                                    AR1085933
     C**********         ENDIF                                                    AR958654 AR1085933
      *                                                                           AR958654 AR1085933
     C                   EXSR      WriteRec
      *
     C                   ENDIF                                                              AR989186
      *                                                                                     AR989186
     C                   ENDSR                                                              MD019911
      *****************************************************************                     MD019911
      /EJECT                                                                                MD019911
     C*/EXEC*SQL*******************************************************                     MD019911
     C*+*FETCH*NEXT****************************************************                     MD019911
     C*+*FROM*GRcursor*************************************************                     MD019911
     C*+*INTO:*GrpId***************************************************                     MD019911
     C*/END-EXEC*******************************************************                     MD019911
      *****************************************************************                     MD019911
     C*******************ENDDO*****************************************                     MD019911
      *****************************************************************                     MD019911
     C*/EXEC*SQL*******************************************************                     MD019911
     C*+*CLOSE*GRcursor************************************************                     MD019911
     C*/END-EXEC*******************************************************                     MD019911
     C*******************ENDSR*****************************************                     MD019911
      *****************************************************************                     MD019911
      */EJECT**********************************************************                     MD019911
      *****************************************************************
      *****************************************************************                     MD019911
      ***RtvBrch*-*Retrieve*branch*************************************                     MD019911
      *****************************************************************                     MD019911
      *****************************************************************
     C*****RtvBrch*******BEGSR*****************************************                     MD019911
      *****************************************************************                     MD019911
     C*/EXEC*SQL********************************************************                    MD019911
     C*+*DECLARE*BRcursor*CURSOR*FOR***********************************                     MD019911
     C*+*SELECT***FROM*SMBFUBPD****************************************                     MD019911
     C*+*WHERE*UBUSER*=*:UsrNam****************************************                     MD019911
     C*/END-EXEC*******************************************************                     MD019911
      *****************************************************************                     MD019911
     C*/EXEC*SQL*******************************************************                     MD019911
     C*+*OPEN*BRcursor*************************************************                     MD019911
     C*/END-EXEC*******************************************************                     MD019911
      *****************************************************************                     MD019911
     C*/EXEC*SQL*******************************************************                     MD019911
     C*+*FETCH*NEXT****************************************************                     MD019911
     C*+*FROM*BRcursor*************************************************                     MD019911
     C*+*INTO:*BRANCH**************************************************                     MD019911
     C*/*END-EXEC******************************************************                     MD019911
      *****************************************************************                     MD019911
     C*******************DOW*******SQLCODE*=*0*************************                     MD019911
      *****************************************************************                     MD019911
     C*******************EVAL******EntVal*=*UBBRCH*********************                     MD019911
      *****************************************************************                     MD019911
     C*******************EXSR******RtvGrp******************************                     MD019911
      *****************************************************************                     MD019911
     C*/EXEC*SQL*******************************************************                     MD019911
     C*+*FETCH*NEXT****************************************************                     MD019911
     C*+*FROM*BRcursor*************************************************                     MD019911
     C*+*INTO:*BRANCH**************************************************                     MD019911
     C*/END-EXEC*******************************************************                     MD019911
      *****************************************************************                     MD019911
     C*******************ENDDO*****************************************                     MD019911
      *****************************************************************                     MD019911
     C*/EXEC*SQL*******************************************************                     MD019911
     C*+*CLOSE*BRcursor************************************************                     MD019911
     C*/END-EXEC*******************************************************                     MD019911
     C*******************ENDSR*****************************************                     MD019911
      *****************************************************************
      */EJECT**********************************************************                     MD019911
      *****************************************************************
      *                                                               *
      *  WriteRec - Write records to BankFusion tables                *
      *                                                               *
      *****************************************************************
      *
     C     WriteRec      BEGSR
      *
     C*/EXEC*SQL*******************************************************                     AR924843
     C*+*INSERT*INTO*BFTB_ENTITLEMENTS(********************************                     AR924843
     C*+*BFIDPK,*BFGROUPNAME,*BFENTITLEMENTTYPE,*BFENTITLEMENTVALUE,***                     AR924843
     C*+*BFAPPLICATIONID,*BFUSERNAME,**VERSIONNUM**********************                     AR924843
     C*+*)*************************************************************                     AR924843
     C*+*VALUES(*******************************************************                     AR924843
     C*+*:IdPkNum,*:GName,*:EntTyp,*:EntVal,***************************                     AR924843
     C*+*:AppId,*:UsrNam,*:VerNum**************************************                     AR924843
     C*+*)*************************************************************                     AR924843
     C*/END-EXEC*******************************************************                     AR924843
      *
      ** Setup description from branch description                                          MD022486
     C/EXEC SQL                                                                             MD022486
     C+ SELECT A8BRNM INTO :Description FROM GZSDBRCHPD WHERE A8BRCD =                      MD022486
     C+ :EntVal                                                                             MD022486
     C/END-EXEC                                                                             MD022486
      *                                                                                     MD022486
     C/EXEC SQL
     C+ INSERT INTO BFTB_ENTITLEMENTS(
     C+ BFIDPK, BFGROUPNAME, BFENTITLEMENTTYPE, BFENTITLEMENTVALUE,
     C*+*BFAPPLICATIONID,*BFUSERNAME,**VERSIONNUM**********************                     MD022486
     C+ BFAPPLICATIONID, BFUSERNAME,  VERSIONNUM, BFDESCRIPTION                             MD022486
     C+ )
     C+ VALUES(
     C*+*:IdPkNum,*:GName,*:EntTyp2,*:EntVal,**************************                     MD020456
     C*+*char(:IdPkNum),*:GName,*:EntTyp2,*:EntVal,********************            MD020456 MD022486
     C*+*:AppId,*:UsrNam,*:VerNum**************************************                     MD022486
     C+ char(:IdPkNum), trim(:GName), trim(:Enttyp2), :EntVal,                              MD022486
     C+ :AppId, trim(:UsrNam), :VerNum, trim(:Description)                                  MD022486
     C+ )
     C/END-EXEC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
